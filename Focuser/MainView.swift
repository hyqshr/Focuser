import SwiftUI

struct MainView: View {
    @AppStorage("currentFocus") var currentFocus: String = ""
    @AppStorage("soundOn") var soundOn: Bool = false

    @State private var newItemName: String = ""
    @State private var todoItems: [Task] = []
    @State private var selectedMinutes: Int = 20
    @State private var selectedHours: Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var countdownTimer = 20
    @State var breakTimer = 15
    @State var timerRunning = false
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
            
            List(todoItems) { item in
                HStack() {
                    Text(item.name)
                    Text("\(item.time)")
                        .foregroundColor(item.color)
                    ProgressView(value: Double(item.time) / Double(maxTotalMinutes))
                                .progressViewStyle(LinearProgressViewStyle())
                                .onReceive(timer) { _ in
                                    // Update the time property of the first task
                                    if let index = todoItems.indices.first {
                                        if countdownTimer > 0 && timerRunning {
                                            todoItems[index].time -= 1
                                        } else {
                                            timerRunning = false
                                        }
                                        
                                    }
                                }
                }
            }
            Divider()
            HStack{
                Text("Focus Time:")
                Picker(selection: $countdownTimer, label: Text("Minutes")) {
                                ForEach(0...60, id: \.self) { minute in
                                    Text("\(minute) minutes")
                                }
                            }
                            .labelsHidden()
            }
            HStack{
                Text("Break Time: ")
                Picker(selection: $breakTimer, label: Text("Minutes")) {
                                ForEach(0...60, id: \.self) { minute in
                                    Text("\(minute) minutes")
                                }
                            }
                            .labelsHidden()
            }
            
            
            Text("\(countdownTimer) min")
                .padding()
                .onReceive(timer) { _ in
                    if countdownTimer > 0 && timerRunning {
                        countdownTimer -= 1
                    } else if countdownTimer == 0 && timerRunning{
                        NotificationManager().pushWorkTimeDone()
                        timerRunning = false
                    } else{
                        
                    }
                    
                }
                .font(.system(size: 40, weight: .bold))
            
            HStack(spacing:30) {
                Button("Start") {
                    timerRunning = true
                }
                Button("Stop") {
                    timerRunning = false
                }
            }
            
        }
        .padding()
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
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        
        MainView()
        
    }
}
