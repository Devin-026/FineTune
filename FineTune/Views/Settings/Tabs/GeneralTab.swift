// FineTune/Views/Settings/Tabs/GeneralTab.swift
import SwiftUI

@MainActor
struct GeneralTab: View {
    @Bindable var settings: SettingsManager
    let onResetAll: () -> Void

    @State private var showResetConfirmation = false
    @AppStorage("interfaceLanguage") private var interfaceLanguage = "system"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                generalSection
                menuBarSection
                dataSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollIndicators(.never)
        .confirmationDialog(
            String(localized: "Reset all settings?"),
            isPresented: $showResetConfirmation,
            titleVisibility: .visible
        ) {
            Button(String(localized: "Reset"), role: .destructive) { onResetAll() }
            Button(String(localized: "Cancel"), role: .cancel) {}
        } message: {
            Text(String(localized: "This cannot be undone."))
        }
    }

    // MARK: - General

    private var generalSection: some View {
        SettingsSection(String(localized: "General")) {
            SettingsRow(
                String(localized: "Language"),
                description: String(localized: "Restart FineTune to apply the language change.")
            ) {
                Picker("", selection: $interfaceLanguage) {
                    Text(String(localized: "Follow macOS")).tag("system")
                    Text(verbatim: "简体中文").tag("zh-Hans")
                    Text(verbatim: "English").tag("en")
                }
                .labelsHidden()
                .frame(minWidth: 130)
                .onChange(of: interfaceLanguage) { _, language in
                    // AppleLanguages is app-scoped. Bundle language changes on next launch.
                    if language == "system" {
                        UserDefaults.standard.removeObject(forKey: "AppleLanguages")
                    } else {
                        UserDefaults.standard.set([language], forKey: "AppleLanguages")
                    }
                }
            }
            SettingsRowDivider()
            SettingsRow(
                String(localized: "Launch at Login"),
                description: String(localized: "Start FineTune when you log in")
            ) {
                Toggle("", isOn: $settings.appSettings.launchAtLogin)
                    .toggleStyle(.switch)
                    .controlSize(.small)
                    .labelsHidden()
            }
            SettingsRowDivider()
            SettingsRow(
                String(localized: "Theme"),
                description: String(localized: "Match macOS, or lock to Light or Dark")
            ) {
                ThemeTilePicker(selection: $settings.appSettings.appearance)
            }
            SettingsRowDivider()
            SettingsRow(
                String(localized: "Device Disconnect Alerts"),
                description: String(localized: "Show notification when an audio device disconnects")
            ) {
                Toggle("", isOn: $settings.appSettings.showDeviceDisconnectAlerts)
                    .toggleStyle(.switch)
                    .controlSize(.small)
                    .labelsHidden()
            }
        }
    }

    // MARK: - Menu Bar

    private var menuBarSection: some View {
        SettingsSection(String(localized: "Menu Bar")) {
            SettingsRow(
                String(localized: "Icon Style"),
                description: String(localized: "How FineTune appears in your menu bar")
            ) {
                IconStyleSegmentedControl(selection: $settings.appSettings.menuBarIconStyle)
            }
            SettingsRowDivider()
            SettingsRow(
                String(localized: "Popup Size"),
                description: String(localized: "Smaller fits more on screen; larger leaves more breathing room.")
            ) {
                PopupSizeTilePicker(selection: $settings.appSettings.popupSize)
            }
        }
    }

    // MARK: - Data

    private var dataSection: some View {
        SettingsSection(String(localized: "Data")) {
            SettingsRow(
                String(localized: "Reset All Settings"),
                description: String(localized: "Clear all volumes, EQ, and device routings")
            ) {
                Button(role: .destructive) {
                    showResetConfirmation = true
                } label: {
                    Text(String(localized: "Reset"))
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .controlSize(.small)
            }
        }
    }
}
