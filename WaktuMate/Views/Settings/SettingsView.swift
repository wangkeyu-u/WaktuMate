import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppStateViewModel
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showingClearConfirmation = false

    var body: some View {
        NavigationStack {
            ZStack {
                FaithBackgroundView(profile: appState.selectedFaithProfile)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        settingsHeader
                        profileSection
                        languageSection
                        statsSection
                        personalSection
                        attributesSection
                        holidaySection
                        if appState.selectedFaithProfile.supportsPrayerTimes {
                            zoneSection
                            notificationSection
                        }
                        displaySection
                        dangerSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, AppLayout.tabPageTopPadding)
                    .padding(.bottom, AppLayout.tabPageBottomPadding)
                }
                .smoothScroll()
                .wmTabSafeScroll()
            }
            .navigationTitle(appState.text("Settings", "Tetapan", "设置"))
            .wmNavigationBar()
            .onAppear {
                viewModel.reloadProfileScopedData(for: appState.selectedFaithProfile.id)
            }
            .onChange(of: appState.selectedFaithProfile.id) { _, newValue in
                viewModel.reloadProfileScopedData(for: newValue)
            }
            .confirmationDialog(appState.text("Clear all local data?", "Padam semua data tempatan?", "清除所有本地数据？"), isPresented: $showingClearConfirmation, titleVisibility: .visible) {
                Button(appState.text("Clear Data", "Padam Data", "清除数据"), role: .destructive) {
                    viewModel.clearLocalData()
                }
                Button(appState.text("Cancel", "Batal", "取消"), role: .cancel) {}
            } message: {
                Text(appState.text(
                    "This resets tracker records, tasbih counts, zone, and notification preferences.",
                    "Ini menetapkan semula rekod jejak, kiraan tasbih, zon dan pilihan peringatan.",
                    "这会重置打卡记录、念珠计数、地区和提醒设置。"
                ))
            }
        }
    }

    private var settingsHeader: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(Color.wmPrimaryDark, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

                VStack(alignment: .leading, spacing: 5) {
                    Text(appState.text("Control Center", "Pusat Kawalan", "控制中心"))
                        .font(.title2.bold())
                    Text(appState.text(
                        "Profile, language, reminders, and local data in one place.",
                        "Profil, bahasa, peringatan dan data setempat di satu tempat.",
                        "集中管理版本、语言、提醒和本地数据。"
                    ))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
            }

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 8) {
                    settingsPill(appState.selectedFaithProfile.localizedDisplayName(appState.language), systemImage: appState.selectedFaithProfile.symbolName)
                    settingsPill(appState.language.displayName, systemImage: "character.bubble.fill")
                    if appState.selectedFaithProfile.supportsPrayerTimes {
                        settingsPill(viewModel.selectedZone.id, systemImage: "mappin.and.ellipse")
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    settingsPill(appState.selectedFaithProfile.localizedDisplayName(appState.language), systemImage: appState.selectedFaithProfile.symbolName)
                    settingsPill(appState.language.displayName, systemImage: "character.bubble.fill")
                    if appState.selectedFaithProfile.supportsPrayerTimes {
                        settingsPill(viewModel.selectedZone.id, systemImage: "mappin.and.ellipse")
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        }
    }

    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(appState.text("Faith Profile", "Profil Agama", "信仰版本"))
                .font(.headline)

            Picker(appState.text("Version", "Versi", "版本"), selection: Binding(
                get: { appState.selectedFaithProfile.id.rawValue },
                set: {
                    let profile = FaithProfile.profile(for: $0)
                    appState.updateFaithProfile(profile)
                    viewModel.reloadProfileScopedData(for: profile.id)
                }
            )) {
                ForEach(FaithProfile.all) { profile in
                    Label(profile.localizedDisplayName(appState.language), systemImage: profile.symbolName)
                        .tag(profile.id.rawValue)
                }
            }
            .pickerStyle(.navigationLink)

            Text(appState.selectedFaithProfile.localizedSubtitle(appState.language))
                .font(.footnote)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .wmCard()
    }

    private var languageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(appState.text("Language", "Bahasa", "语言"))
                .font(.headline)

            ForEach(AppLanguage.allCases) { language in
                languageRow(language)
            }
        }
        .wmCard()
    }

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(appState.text("Practice Stats", "Statistik Amalan", "练习统计"))
                .font(.headline)

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 12) {
                    activeDaysTile
                    profileSpecificStatsTile
                }

                VStack(spacing: 12) {
                    activeDaysTile
                    profileSpecificStatsTile
                }
            }

            if appState.selectedFaithProfile.id == .islam {
                statTile(
                    title: appState.text("Tasbih Total", "Jumlah Tasbih", "念珠总数"),
                    value: "\(viewModel.practiceStats.tasbihTotal)",
                    icon: "circle.grid.cross.fill"
                )
            }
        }
        .wmCard()
    }

    private var personalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(appState.text("Private Profile", "Profil Peribadi", "私人资料"))
                .font(.headline)

            TextField(appState.text("Display name", "Nama paparan", "显示名称"), text: Binding(
                get: { viewModel.personalProfile.displayName },
                set: {
                    viewModel.personalProfile.displayName = $0
                    viewModel.savePersonalProfile(for: appState.selectedFaithProfile.id)
                }
            ))
            .textFieldStyle(.roundedBorder)

            ForEach(appState.selectedFaithProfile.personalQuestionPrompts(appState.language), id: \.self) { question in
                Text(question)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }

            TextField(appState.text("Community / place", "Komuniti / tempat", "社群 / 场所"), text: Binding(
                get: { viewModel.personalProfile.communityName },
                set: {
                    viewModel.personalProfile.communityName = $0
                    viewModel.savePersonalProfile(for: appState.selectedFaithProfile.id)
                }
            ))
            .textFieldStyle(.roundedBorder)

            TextField(appState.text("Practice goal", "Matlamat amalan", "练习目标"), text: Binding(
                get: { viewModel.personalProfile.practiceGoal },
                set: {
                    viewModel.personalProfile.practiceGoal = $0
                    viewModel.savePersonalProfile(for: appState.selectedFaithProfile.id)
                }
            ))
            .textFieldStyle(.roundedBorder)

            TextField(appState.text("Preferred time", "Masa pilihan", "偏好时间"), text: Binding(
                get: { viewModel.personalProfile.preferredPracticeTime },
                set: {
                    viewModel.personalProfile.preferredPracticeTime = $0
                    viewModel.savePersonalProfile(for: appState.selectedFaithProfile.id)
                }
            ))
            .textFieldStyle(.roundedBorder)
        }
        .wmCard()
    }

    private var attributesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(appState.text("Faith Attributes", "Sifat Profil", "教派属性"))
                .font(.headline)

            ForEach(appState.selectedFaithProfile.attributes(appState.language), id: \.self) { attribute in
                Label(attribute, systemImage: "checkmark.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
            }
        }
        .wmCard()
    }

    private var holidaySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(appState.text("Holiday Reminders", "Peringatan Perayaan", "节日提醒"))
                .font(.headline)

            Toggle(appState.text("System notifications", "Notifikasi sistem", "系统消息提醒"), isOn: Binding(
                get: { viewModel.holidayRemindersEnabled },
                set: { viewModel.setHolidayRemindersEnabled($0, faith: appState.selectedFaithProfile.id, language: appState.language) }
            ))
            .tint(.wmPrimary)

            Picker(appState.text("Remind before", "Ingatkan sebelum", "提前提醒"), selection: Binding(
                get: { viewModel.holidayReminderDaysBefore },
                set: { viewModel.setHolidayReminderDaysBefore($0, faith: appState.selectedFaithProfile.id, language: appState.language) }
            )) {
                ForEach(viewModel.holidayReminderOptions, id: \.self) { days in
                    Text(appState.text("\(days)d", "\(days)h", "\(days)天")).tag(days)
                }
            }
            .pickerStyle(.menu)

            ForEach(FaithHoliday.upcoming(for: appState.selectedFaithProfile.id, limit: 4)) { holiday in
                holidayRow(holiday)
            }

            if let holidayMessage = viewModel.holidayMessage {
                Text(holidayMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .wmCard()
    }

    private var zoneSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(appState.text("Malaysia Zone", "Zon Malaysia", "马来西亚地区"))
                .font(.headline)

            ZonePickerView(selectedZone: Binding(
                get: { viewModel.selectedZone },
                set: { viewModel.updateZone($0) }
            ))
        }
        .wmCard()
    }

    private var notificationSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(appState.text("Prayer Notifications", "Peringatan Solat", "礼拜提醒"))
                .font(.headline)

            Toggle(appState.text("Enable Prayer Notifications", "Aktifkan Peringatan Solat", "开启礼拜提醒"), isOn: Binding(
                get: { viewModel.notificationsEnabled },
                set: { viewModel.setNotificationsEnabled($0) }
            ))
            .tint(.wmPrimary)

            Picker(appState.text("Notify before", "Ingatkan sebelum", "提前提醒"), selection: Binding(
                get: { viewModel.reminderOffsetMinutes },
                set: { viewModel.setReminderOffset($0) }
            )) {
                Text(appState.text("At time", "Pada waktu", "准点")).tag(0)
                ForEach(viewModel.reminderOptions.filter { $0 > 0 }, id: \.self) { minutes in
                    Text(appState.text("\(minutes)m before", "\(minutes)m sebelum", "提前\(minutes)分钟")).tag(minutes)
                }
            }

            ForEach(PrayerName.allCases) { prayer in
                Toggle(prayer.localizedName(appState.language), isOn: Binding(
                    get: { viewModel.enabledPrayers[prayer] ?? true },
                    set: { viewModel.setPrayer(prayer, enabled: $0) }
                ))
                .tint(.wmPrimary)
            }

            if let permissionMessage = viewModel.permissionMessage {
                Text(permissionMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .wmCard()
    }

    private var displaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(appState.text("Display", "Paparan", "显示"))
                .font(.headline)

            Picker(appState.text("Time Format", "Format Masa", "时间格式"), selection: Binding(
                get: { viewModel.uses24HourTime },
                set: { viewModel.setUses24HourTime($0) }
            )) {
                Text("24-hour").tag(true)
                Text("12-hour").tag(false)
            }
            .pickerStyle(.segmented)
        }
        .wmCard()
    }

    private var dangerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(appState.text("Data", "Data", "数据"))
                .font(.headline)

            Button(role: .destructive) {
                showingClearConfirmation = true
            } label: {
                Label(appState.text("Clear Local Data", "Padam Data Tempatan", "清除本地数据"), systemImage: "trash")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.smoothPress)
        }
        .wmCard()
    }

    private func statTile(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(Color.wmPrimary)
            Text(value)
                .font(.title2.bold())
                .minimumScaleFactor(0.84)
                .lineLimit(1)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.tertiarySystemGroupedBackground).opacity(0.72), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func settingsPill(_ text: String, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(Color(.tertiarySystemGroupedBackground).opacity(0.82), in: Capsule())
    }

    private var activeDaysTile: some View {
        statTile(
            title: appState.text("Active Days", "Hari Aktif", "活跃天数"),
            value: "\(viewModel.practiceStats.activeDays)",
            icon: "calendar"
        )
    }

    @ViewBuilder
    private var profileSpecificStatsTile: some View {
        if appState.selectedFaithProfile.id == .islam {
            statTile(
                title: appState.text("Prayer Days", "Hari Solat", "礼拜完成天数"),
                value: "\(viewModel.practiceStats.trackerCompletedDays)",
                icon: "checkmark.seal.fill"
            )
        } else {
            statTile(
                title: appState.text("Timer Minutes", "Minit Pemasa", "定时分钟"),
                value: "\(viewModel.practiceStats.timerMinutes)",
                icon: "timer"
            )
        }
    }

    private func languageRow(_ language: AppLanguage) -> some View {
        Button {
            appState.updateLanguage(language)
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: language == appState.language ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(language == appState.language ? Color.wmPrimary : .secondary)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 4) {
                    Text(language.displayName)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(language.interfaceDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)

                Spacer(minLength: 0)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                language == appState.language ? Color.wmMint.opacity(0.72) : Color(.tertiarySystemGroupedBackground).opacity(0.72),
                in: RoundedRectangle(cornerRadius: 14, style: .continuous)
            )
        }
        .buttonStyle(.smoothPress)
    }

    private func holidayRow(_ holiday: FaithHoliday) -> some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: 12) {
                holidayText(holiday)
                Spacer(minLength: 8)
                holidayCalendarButton(holiday)
            }

            VStack(alignment: .leading, spacing: 10) {
                holidayText(holiday)
                holidayCalendarButton(holiday)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.tertiarySystemGroupedBackground).opacity(0.72), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func holidayText(_ holiday: FaithHoliday) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(holiday.name.text(appState.language))
                .font(.subheadline.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)
            Text(holiday.date)
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
            Text(holiday.notes.text(appState.language))
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .layoutPriority(1)
    }

    private func holidayCalendarButton(_ holiday: FaithHoliday) -> some View {
        Button {
            viewModel.addHolidayToCalendar(holiday, language: appState.language)
        } label: {
            Label(appState.text("Add to Calendar", "Tambah ke Kalendar", "加入日历"), systemImage: "calendar.badge.plus")
                .labelStyle(.iconOnly)
                .frame(width: 34, height: 34)
        }
        .buttonStyle(.bordered)
        .tint(.wmPrimary)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppStateViewModel())
}
