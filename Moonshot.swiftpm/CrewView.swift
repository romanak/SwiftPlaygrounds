import SwiftUI

struct CrewView: View {
    var crew: [MissionView.CrewMember]
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(.lightBackground)
                    .padding(.vertical)
                
                Text("Crew")
                    .font(.title.bold())
                    .padding(.bottom, 5)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(crew, id: \.role) { crewMember in
                        NavigationLink {
                            AstronautView(astronaut: crewMember.astronaut)
                        } label: {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 104, height: 72)
                                    .clipShape(Capsule()) // .capsule
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(.white, lineWidth: 1)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .foregroundStyle(.white)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

struct CrewView_Previews: PreviewProvider {
    static var previews: some View {
        
        let missions: [Mission] = Bundle.main.decode("missions.json")
        let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
        
        let mission = missions[0]
        let crew: [MissionView.CrewMember] = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return MissionView.CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
        
        CrewView(crew: crew)
            .preferredColorScheme(.dark)
    }
}
