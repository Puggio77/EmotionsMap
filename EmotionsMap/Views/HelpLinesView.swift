//
//  HelpLinesView.swift
//  EmotionsMap
//
//  Created by Riccardo.
//

import SwiftUI

struct HelpLine: Identifiable {
    let id = UUID()
    let country: String
    let numbers: String
}

struct HelpRegion: Identifiable {
    let id = UUID()
    let name: String
    let lines: [HelpLine]
}

struct HelpLinesView: View {
    @Environment(\.dismiss) private var dismiss
    
    let regions: [HelpRegion] = [
        HelpRegion(name: "America", lines: [
            HelpLine(country: "🇦🇷 Argentina", numbers: "135 (CABA/GBA) • 0800-345-1435 (National) • (011) 5275-1135"),
            HelpLine(country: "🇧🇴 Bolivia", numbers: "800-113-040 (Familia Segura) • 2248486 (Teléfono de la Esperanza)"),
            HelpLine(country: "🇧🇷 Brazil", numbers: "188 (CVV - Centro de Valorização da Vida)"),
            HelpLine(country: "🇨🇦 Canada", numbers: "9-8-8 (Crisis Line) • 1-833-456-4566"),
            HelpLine(country: "🇨🇱 Chile", numbers: "*4141 (Suicide Prevention) • 600-360-7777 (Salud Responde)"),
            HelpLine(country: "🇨🇴 Colombia", numbers: "106 (Bogotá) • 01-8000-113-113 (National) • 192 (Option 4)"),
            HelpLine(country: "🇨🇷 Costa Rica", numbers: "9-1-1 • 2272-3774 (Línea de la Esperanza) • 1322"),
            HelpLine(country: "🇨🇺 Cuba", numbers: "103 (National Help Line)"),
            HelpLine(country: "🇩🇴 Dominican Republic", numbers: "809-620-2433 • 809-562-3500 • *462"),
            HelpLine(country: "🇪🇨 Ecuador", numbers: "171 (Option 6) • 9-1-1 • (02) 600-3388"),
            HelpLine(country: "🇸🇻 El Salvador", numbers: "131 (FOSALUD) • 2231-9620 (Teléfono de la Esperanza)"),
            HelpLine(country: "🇬🇹 Guatemala", numbers: "1501 (Mental Health) • 2232-2139 • 2335-4604"),
            HelpLine(country: "🇭🇳 Honduras", numbers: "150 (Línea de Esperanza) • 2232-1314 • 2558-0808"),
            HelpLine(country: "🇲🇽 Mexico", numbers: "800-911-2000 (Línea de la Vida) • 55-5259-8121 (SAPTEL)"),
            HelpLine(country: "🇳🇮 Nicaragua", numbers: "9-1-1 • 118 • 2278-6191"),
            HelpLine(country: "🇵🇦 Panama", numbers: "523-6800 • 523-6846 • (507) 204-8242 (Te Escucho)"),
            HelpLine(country: "🇵🇾 Paraguay", numbers: "154 (Option 4) • (021) 310-452"),
            HelpLine(country: "🇵🇪 Peru", numbers: "113 (Option 5) • 0800-4-1212 (La Voz de la Esperanza)"),
            HelpLine(country: "🇵🇷 Puerto Rico", numbers: "9-8-8 • 1-800-981-0023 (Línea PAS)"),
            HelpLine(country: "🇺🇸 United States", numbers: "9-8-8 (Suicide & Crisis Lifeline) • 1-888-628-9454 (Spanish)"),
            HelpLine(country: "🇺🇾 Uruguay", numbers: "0800-0767 • *0767 (Suicide Prevention) • 0800-1920 (Emotional Support)"),
            HelpLine(country: "🇻🇪 Venezuela", numbers: "0241-843-3308 • 0412-416-3117 (Psicólogos sin Fronteras)")
        ]),
        HelpRegion(name: "Europe", lines: [
            HelpLine(country: "🇦🇹 Austria", numbers: "142 (Notruf) • 01-713-3374"),
            HelpLine(country: "🇧🇪 Belgium", numbers: "1813 (Zelfmoordlijn) • 107 (Télé-Accueil)"),
            HelpLine(country: "🇫🇷 France", numbers: "3114 (Appel National) • 01-45-39-40-00"),
            HelpLine(country: "🇩🇪 Germany", numbers: "0800-111-0-111 • 0800-111-0-222"),
            HelpLine(country: "🇬🇷 Greece", numbers: "1018 (Prevention Line) • 10306"),
            HelpLine(country: "🇮🇪 Ireland", numbers: "116-123 (Samaritans) • (01) 671-0071"),
            HelpLine(country: "🇮🇹 Italy", numbers: "02-2327-2327 (Telefono Amico) • 800-86-00-22"),
            HelpLine(country: "🇵🇹 Portugal", numbers: "808-24-24-24 (SNS24) • 213-544-545"),
            HelpLine(country: "🇪🇸 Spain", numbers: "024 (National Suicide Line) • 717-003-717 (Hope Line)"),
            HelpLine(country: "🇸🇪 Sweden", numbers: "90101 (MIND) • 1177 (Vårdguiden)"),
            HelpLine(country: "🇨🇭 Switzerland", numbers: "143 (La Main Tendue) • 147 (Youth Line)"),
            HelpLine(country: "🇬🇧 United Kingdom", numbers: "111 • 999 • 0800-689-5652 (National Suicide Helpline)")
        ]),
        HelpRegion(name: "Oceania, Asia & Africa", lines: [
            HelpLine(country: "🇦🇺 Australia", numbers: "13-11-14 (Lifeline) • 1300-659-467 (Suicide Call Back Service)"),
            HelpLine(country: "🇨🇳 China", numbers: "010-8295-1332 • 800-810-1117"),
            HelpLine(country: "🇪🇬 Egypt", numbers: "0800-888-0700 • 0220816831"),
            HelpLine(country: "🇮🇳 India", numbers: "9152987821 (iCALL) • 022-25521111"),
            HelpLine(country: "🇯🇵 Japan", numbers: "0570-783-556 • 0120-783-556"),
            HelpLine(country: "🇳🇿 New Zealand", numbers: "1737 (Need to talk?) • 0800-543-354"),
            HelpLine(country: "🇵🇭 Philippines", numbers: "1553 (Hopeline) • 0917-558-4673"),
            HelpLine(country: "🇿🇦 South Africa", numbers: "0800-567-567 • 0800-456-789"),
            HelpLine(country: "🇰🇷 South Korea", numbers: "1393 • 1577-0199"),
            HelpLine(country: "🇰🇿 Kazakhstan", numbers: "111 (National Youth Line) • 150 (Crisis Hotline)"),
            HelpLine(country: "🇰🇬 Kyrgyzstan", numbers: "111 (Children's Hotline) • 118 (General Health Support)"),
            HelpLine(country: "🇹🇯 Tajikistan", numbers: "(+992) 372 21 21 21 (National Support Line)"),
            HelpLine(country: "🇹🇲 Turkmenistan", numbers: "9-1-1 (Emergency only - limited dedicated mental health lines)"),
            HelpLine(country: "🇺🇿 Uzbekistan", numbers: "1003 (Health Support Line) • (+998) 71 233 83 62"),
            HelpLine(country: "🇮🇷 Iran", numbers: "123 (Social Emergency) • 1480 (Counseling Line)"),
            HelpLine(country: "🇮🇱 Israel", numbers: "1201 (ERAN - Emotional First Aid) • 105 (Child Protection)"),
            HelpLine(country: "🇯🇴 Jordan", numbers: "110 (Family Protection) • 06 553 3551"),
            HelpLine(country: "🇱🇧 Lebanon", numbers: "1564 (Embrace Lifeline)"),
            HelpLine(country: "🇸🇦 Saudi Arabia", numbers: "920033359 (National Mental Health) • 199099"),
            HelpLine(country: "🇹🇷 Turkey", numbers: "182 (Mental Health Appointments) • 112 (Emergency)"),
            HelpLine(country: "🇦🇪 United Arab Emirates", numbers: "800-4673 (HOPE Hotline)")
        ])
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(regions) { region in
                    Section(header: Text(region.name)) {
                        ForEach(region.lines) { line in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(line.country)
                                    .font(.headline)
                                Text(line.numbers)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Psychological Help")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    HelpLinesView()
}
