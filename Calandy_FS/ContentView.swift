//
//  ContentView.swift
//  Calandy_FS
//
//  Created by Frank Cipolla on 3/1/24.
//

import SwiftUI

struct ContentView: View {
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @State var selectedMonth = 0
    @State var selectedDate = Date()
    
    var body: some View {
        VStack {
            Image("FrankBlackHat")
                .resizable()
                .scaledToFill()
                .frame(width: 128, height: 128)
                .cornerRadius( 64)
               
            Text("Calendy FS")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
            
            VStack(spacing: 20){
                
                Text("Select a Day")
                    .font(.title2)
                    .bold()
                HStack {    // Month Selection
                    
                    Spacer()
                    Button {
                        withAnimation{selectedMonth -= 1
                        }
                    } label: {
                        Image(systemName: "lessthan")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 28)
                    }
                    
                    Spacer()
                    Text(selectedDate.monthAndYear())
                        .font(.title2)
                    Spacer()
                    
                    Button {
                        withAnimation{selectedMonth += 1
                        }
                    } label: {
                        Image(systemName: "greaterthan")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 28)
                    }
                    Spacer()
                    
                }
                
                
                HStack {
                    ForEach(days, id: \.self) {day in
                        Text(day)
                            .font(.system(size: 12, weight: .medium))
                        .frame(maxWidth: .infinity)}
                }
            }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 20) {
                    ForEach(fetchDates()) { value in
                        ZStack {
                            if value.day != -1 {
                                Text("\(value.day)")
                                    .foregroundColor(value.day % 2 != 0 ? .blue : .black)
                                    .fontWeight(value.day % 2 != 0 ? .bold : .none)
                                    .background{
                                        ZStack(alignment: .bottom) {
                                            Circle()
                                                .frame(width: 48, height: 48)
                                                .foregroundColor(value.day % 2 != 0 ? .blue.opacity(0.1) : .clear)
                                            if value.date.mmddyyy() == Date().mmddyyy() {
                                                Circle()
                                                    .frame(width: 8, height: 8)
                                                    .foregroundColor(value.day % 2 != 0 ? .blue.opacity(0.1) : .gray)
                                            }
                                            }
                                        }
                                               
                            } else {
                                Text("")
                            }
                        }
                        .frame(width: 32, height: 32)
                    }
                }
//            let currentMonth = fetchSelectedMonth()
//            Text("\(currentMonth)")
                .onChange(of: selectedMonth){
                    selectedDate = fetchSelectedMonth()
                }
                .frame(maxHeight: .infinity, alignment: .top)
        }
             .padding()
    }
    
    func fetchDates() -> [CalendarDate] {
        let calendar = Calendar.autoupdatingCurrent
        let currentMonth = fetchSelectedMonth()
        var dates: [CalendarDate] = currentMonth.getDaysInMonth().map({CalendarDate(day: calendar.component(.day, from: $0), date: $0)})
        
        let firstDayOfWeek = calendar.component(.weekday, from: dates.first?.date ?? Date() )
        
        for _ in 0..<firstDayOfWeek - 1 {
            dates.insert(CalendarDate(day: -1, date: Date()), at: 0)
        }
        return dates
    }
    
    func fetchSelectedMonth() -> Date {
        let calendar = Calendar.autoupdatingCurrent
        let month = calendar.date(byAdding: .month, value: selectedMonth, to:Date())
        
        return month!
    }
    
}

struct CalendarDate: Identifiable {
    let id = UUID()
    var day: Int
    var date: Date
}

#Preview {
    ContentView()
}

// MARK: - Extensions

    extension Date {
        
        func monthAndYear() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM YYYY"
            
            return formatter.string(from: self)
        }
        
      //  func getDaysOfMonth() -> [Date]{
        
        func getDaysInMonth() -> [Date] { //_ monthNumber: Int? = nil, _ year: Int? = nil)  -> Int {
            
            let calendar = Calendar.autoupdatingCurrent
            var dateComponents = DateComponents()
            var dates: [Date] = []
            dateComponents.year = calendar.component(.year, from: self)
            dateComponents.month = calendar.component(.month, from: self)
            
            var currentDate = calendar.date(from: dateComponents)!
            let range = calendar.range(of: .day, in: .month, for: calendar.date(from: dateComponents)!)
            let days = (range!.upperBound - 1)
            
            for day in 0..<days {
                dates.append(currentDate)
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            return dates
        }
        
        func mmddyyy() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            return formatter.string(from: self)
        }
}
