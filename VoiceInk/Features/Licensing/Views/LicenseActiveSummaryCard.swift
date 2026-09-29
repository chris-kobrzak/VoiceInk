import SwiftUI

struct LicenseActiveSummaryCard<Actions: View>: View {
    let title: String
    let subtitle: String
    let licenseKey: String
    let didCopyLicenseKey: Bool
    let onCopyLicenseKey: () -> Void
    let actions: () -> Actions
    let showsActions: Bool

    init(
        title: String,
        subtitle: String,
        licenseKey: String,
        didCopyLicenseKey: Bool,
        onCopyLicenseKey: @escaping () -> Void,
        @ViewBuilder actions: @escaping () -> Actions
    ) {
        self.title = title
        self.subtitle = subtitle
        self.licenseKey = licenseKey
        self.didCopyLicenseKey = didCopyLicenseKey
        self.onCopyLicenseKey = onCopyLicenseKey
        self.actions = actions
        self.showsActions = true
    }

    init(
        title: String,
        subtitle: String,
        licenseKey: String,
        didCopyLicenseKey: Bool,
        onCopyLicenseKey: @escaping () -> Void
    ) where Actions == EmptyView {
        self.title = title
        self.subtitle = subtitle
        self.licenseKey = licenseKey
        self.didCopyLicenseKey = didCopyLicenseKey
        self.onCopyLicenseKey = onCopyLicenseKey
        self.actions = { EmptyView() }
        self.showsActions = false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top, spacing: 18) {
                LicenseProMark()

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }

            Divider()

            licenseKeyControl

            if showsActions {
                Divider()

                actions()
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppMaterialCardBackground(cornerRadius: 14))
    }

    private var licenseKeyControl: some View {
        HStack(spacing: 10) {
            Text("License Key")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .frame(width: 82, alignment: .leading)

            Button(action: onCopyLicenseKey) {
                HStack(spacing: 10) {
                    Text(maskedLicenseKey)
                        .font(.system(size: 18, weight: .medium, design: .monospaced))
                        .lineLimit(1)
                        .minimumScaleFactor(0.74)
                        .foregroundStyle(.primary)

                    Spacer(minLength: 10)

                    if didCopyLicenseKey {
                        CopiedStatePill()
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 14)
                .frame(height: 42)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(didCopyLicenseKey ? AppTheme.Surface.controlActive : AppTheme.Surface.control)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(
                            didCopyLicenseKey ? AppTheme.Border.control : AppTheme.Border.subtle,
                            lineWidth: 1
                        )
                }
                .scaleEffect(didCopyLicenseKey ? 0.998 : 1)
                .animation(.smooth(duration: 0.18), value: didCopyLicenseKey)
            }
            .buttonStyle(.plain)
            .help(didCopyLicenseKey ? "Copied" : "Copy License Key")
        }
    }

    private var maskedLicenseKey: String {
        let key = licenseKey.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !key.isEmpty else {
            return "•••• •••• •••• ••••"
        }

        return "•••• •••• •••• \(key.suffix(4))"
    }
}

struct LicenseProMark: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(AppTheme.Surface.control)
                .frame(width: 92, height: 62)
                .rotationEffect(.degrees(-9))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(AppTheme.Border.subtle, lineWidth: 1)
                        .rotationEffect(.degrees(-9))
                )

            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(AppTheme.Surface.materialCard)
                .frame(width: 92, height: 62)
                .rotationEffect(.degrees(8))
                .overlay(
                    VStack(alignment: .leading, spacing: 6) {
                        Text("PRO")
                            .font(.caption)
                            .fontWeight(.semibold)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(AppTheme.Border.control)
                            .frame(width: 48, height: 4)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(AppTheme.Border.subtle)
                            .frame(width: 34, height: 4)
                    }
                    .padding(10)
                    .rotationEffect(.degrees(8))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(AppTheme.Border.card, lineWidth: 1)
                        .rotationEffect(.degrees(8))
                )
        }
        .frame(width: 120, height: 86)
    }
}

private struct CopiedStatePill: View {
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "checkmark")
                .font(.system(size: 11, weight: .semibold))

            Text("Copied")
                .font(.system(size: 11, weight: .medium))
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Capsule().fill(AppTheme.Surface.subtle))
        .overlay {
            Capsule()
                .stroke(AppTheme.Border.subtle, lineWidth: 1)
        }
    }
}

