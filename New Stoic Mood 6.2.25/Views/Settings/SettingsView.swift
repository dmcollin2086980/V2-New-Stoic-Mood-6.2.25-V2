import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var notificationManager = NotificationManager.shared
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("reminderTime") private var reminderTime = Date()
    
    var body: some View {
        List {
            Section {
                ThemeToggle()
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            } header: {
                Text("Appearance")
            }
            
            Section {
                Toggle("Daily Reminders", isOn: $notificationsEnabled)
                    .tint(themeManager.accentColor)
                    .onChange(of: notificationsEnabled) { oldValue, newValue in
                        if newValue {
                            notificationManager.requestAuthorization()
                        } else {
                            notificationManager.removeDailyReminder()
                        }
                    }
                
                if notificationsEnabled {
                    DatePicker(
                        "Reminder Time",
                        selection: $reminderTime,
                        displayedComponents: .hourAndMinute
                    )
                    .onChange(of: reminderTime) { oldValue, newValue in
                        notificationManager.updateReminderTime()
                    }
                }
            } header: {
                Text("Notifications")
            } footer: {
                if !notificationManager.isAuthorized && notificationsEnabled {
                    Text("Please enable notifications in your device settings to receive daily reminders.")
                        .foregroundColor(themeManager.secondaryTextColor)
                }
            }
            
            Section {
                NavigationLink {
                    Text("Privacy Policy")
                        .navigationTitle("Privacy Policy")
                } label: {
                    Label("Privacy Policy", systemImage: "hand.raised")
                }
                
                NavigationLink {
                    Text("Terms of Service")
                        .navigationTitle("Terms of Service")
                } label: {
                    Label("Terms of Service", systemImage: "doc.text")
                }
            } header: {
                Text("Legal")
            }
            
            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                        .foregroundColor(themeManager.secondaryTextColor)
                }
            } header: {
                Text("About")
            }
        }
        .navigationTitle("Settings")
        .background(themeManager.backgroundColor)
    }
}

#Preview {
    NavigationView {
        SettingsView()
            .environmentObject(ThemeManager())
    }
} 