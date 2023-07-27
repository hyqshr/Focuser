import SwiftUI

enum FocusMode: String, CaseIterable {
    case AfterFocusTime
    case AfterTaskComplete
}

enum TimerStatus: String, CaseIterable{
    case Configuring
    case Focusing
    case Breaking
    case UserStop
}

struct MainView: View {
    @AppStorage("currentFocus") var currentFocus: String = ""
    @AppStorage("soundOn") var soundOn: Bool = false

    @State private var newItemName: String = ""
    @State private var todoItems: [Task] = []
    @State private var selectedMinutes: Int = 20
    @State private var selectedHours: Int = 0
    @State private var selectedFocusMode = FocusMode.AfterTaskComplete
    @State private var selectedFocusTime: Int = 20
    @State var countdownTimer = 0
    @State var timerStatus = TimerStatus.Configuring
    @State var lastTimerStatus = TimerStatus.Breaking
    @State var selectedBreakTime = 15
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var maxTotalMinutes: Int {
        todoItems.map(\.time).max() ?? 1 // If the array is empty, default to 1 minute
    }
    
    var body: some View {
        VStack {
            VStack{
                HStack {
                    Text("Add Task:")
                    TextField("Enter task name here", text: $newItemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                
                HStack {
                    Picker("Hour", selection: $selectedHours) {
                        ForEach(0...4, id: \.self) { hour in
                            Text("\(hour)")
                        }
                    }
                    Picker("Min", selection: $selectedMinutes) {
                        ForEach(0...60, id: \.self) { minute in
                            Text("\(minute)")
                        }
                    }
                    Button("Add", action: addItem)
                }
                
            }.padding()
            
            Divider()
            
            List{
                ForEach(todoItems.indices, id: \.self) { index in
                    let item = todoItems[index]
                    
                    HStack() {
                        Text(item.name)
                        Text("\(item.time)")
                            .foregroundColor(item.color)
                        ProgressView(value: Double(item.time) / Double(maxTotalMinutes))
                            .progressViewStyle(LinearProgressViewStyle())
                            .onReceive(timer) { _ in
                                // Update the time property of the first task
                                if let index = todoItems.indices.first {
                                    if todoItems[index].time > 0 && timerStatus == TimerStatus.Focusing {
                                        todoItems[index].time -= 1
                                    } else if todoItems[index].time == 0 {
                                        
                                    }
                                    
                                }
                            }
                        Button("Finish"){
                            deleteItem(at: index)
                        }
                        
                    }
                    
                }
            }
            .frame(height: 130)
            .border(Color.gray, width: 1)
            Divider()
            HStack{
                Text("Set Break Time: ")
                Picker(selection: $selectedBreakTime, label: Text("Minutes")) {
                                ForEach(0...60, id: \.self) { minute in
                                    Text("\(minute) minutes")
                                }
                            }
                            .labelsHidden()
            }
            VStack(alignment: .leading, spacing: 10){
                Text("How to break?")
                Picker("", selection: $selectedFocusMode) {
                                ForEach(FocusMode.allCases, id: \.self) { focusMode in
                                    Text(focusMode == FocusMode.AfterFocusTime ? "After Focus Time" : "After Each Task Done")
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
            }

            if selectedFocusMode == FocusMode.AfterFocusTime{
                HStack{
                    Text("Focus Time:")
                    Picker(selection: $selectedFocusTime, label: Text("Minutes")) {
                                    ForEach(0...60, id: \.self) { minute in
                                        Text("\(minute) minutes")
                                    }
                                }
                                .labelsHidden()
                }

            }
            
            if timerStatus == TimerStatus.Focusing || timerStatus == TimerStatus.Breaking || timerStatus == TimerStatus.UserStop{
                Text("\(countdownTimer) min")
                    .onReceive(timer) { _ in
                        if countdownTimer > 0 && (timerStatus == TimerStatus.Focusing || timerStatus == TimerStatus.Breaking) {
                            countdownTimer -= 1
                        } else if countdownTimer == 0{
                            NotificationManager().pushWorkTimeDone()
                            timerStatus =  timerStatus == TimerStatus.Focusing ? TimerStatus.Breaking :TimerStatus.Focusing
                            countdownTimer = timerStatus == TimerStatus.Focusing ? selectedFocusTime : selectedBreakTime
                            print("Switch mode to\(timerStatus) and reset timer")
                        } else{
                            
                        }
                        
                    }
                    .font(.system(size: 40, weight: .bold))
                
            } else{
                Text("\(selectedFocusTime) min")
                    .font(.system(size: 40, weight: .bold))
            }

            
            HStack(spacing:30) {
                if timerStatus == TimerStatus.Configuring{
                    Button("Start") {
                        countdownTimer = selectedFocusTime
                        timerStatus = TimerStatus.Focusing
                    }
                } else if timerStatus == TimerStatus.UserStop{
                    Button("Resume") {
                        timerStatus = lastTimerStatus
                    }
                }
                if timerStatus != TimerStatus.UserStop && timerStatus != TimerStatus.Configuring{
                    Button("Pause") {
                        lastTimerStatus = timerStatus
                        timerStatus = TimerStatus.UserStop
                    }
                }

                    
                Button("Reset") {
                    lastTimerStatus = timerStatus
                    timerStatus = TimerStatus.Configuring
                }
            }
            
        }
        .padding()
        .frame(width: 350, height: 500)
    }
        

    func addItem() {
        if !newItemName.isEmpty {
            let totalMinutes = selectedHours * 60 + selectedMinutes
            let newTask = Task(time: totalMinutes, color: .blue, type: "Personal", name: newItemName)
            todoItems.append(newTask)
            newItemName = ""
            selectedHours = 0
            selectedMinutes = 20
        }
    }
    
    func deleteItem(at index: Int) {
        if !todoItems.isEmpty {
            todoItems.remove(at: index)
        }
    }
    
    func persistToJson(){
        
    }
    
}
    

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
        
    }
}
