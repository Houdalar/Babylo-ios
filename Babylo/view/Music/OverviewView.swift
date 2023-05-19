import SwiftUI



struct OverviewView: View {

    @State private var currentPage = 0

    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    @State private var trendingLabelOpacity = 0.0
    @EnvironmentObject var backendService: MusicViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                GeometryReader { geometry in
                    ZStack(alignment: .bottom) {
                        TabView(selection: $currentPage) {
                            ForEach(backendService.newTracks.indices, id: \.self) { index in
                                GeometryReader { geometry in
                                    VStack {
                                                          TrackCardView(track: backendService.newTracks[index], trendingLabelOpacity: trendingLabelOpacity)
                                                      }
                                                      .padding(.horizontal, 20)
                                                      .padding(.top,25)
                                        
                                }
                                .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                                .frame(width: geometry.size.width, height: geometry.size.height)
                                                .onReceive(timer) { _ in
                                                    withAnimation {
                                                        currentPage = (currentPage + 1) % 5
                                                    }
                                                    withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                                        trendingLabelOpacity = trendingLabelOpacity == 1.0 ? 0.0 : 1.0
                                                    }
                                        }
                                                
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .frame(height: 280)
                                .padding(.bottom)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration:1).repeatForever(autoreverses: true)) {
                                        trendingLabelOpacity = 1.0
                                    }
                                }

                HStack {
                    Spacer()
                    PageControl(numberOfPages: 5, currentPage: $currentPage, dotColor: AppColors.primarydark)
                        .padding(.trailing)
                }
                .padding(.bottom, -30)
                .padding(.top,-5)
                VStack(alignment: .leading) {
                                   HStack {
                                       Text("Trending")
                                           .font(.system(size: 20))
                                           .padding(.leading)

                                       Spacer()

                                       Button(action: {
                                           // Handle "See All" button tap
                                       }) {
                                           Text("See All")
                                               .foregroundColor(.gray)
                                               .padding(.trailing)
                                       }
                                   }
                                   .padding(.top, 20) // Add padding here to lower the section

                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 30) {
                            ForEach(backendService.trendingTracks, id: \.id) { track in
                                SmallTrackCardView(track: track)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 10)
                    
                }.padding(.top, 10)

                               // Albums section
                               VStack(alignment: .leading) {
                                   HStack {
                                       Text("Albums")
                                           .font(.system(size: 20))
                                           .padding(.leading)

                                       Spacer()

                                       Button(action: {
                                           // Handle "See All" button tap
                                       }) {
                                           Text("See All")
                                               .foregroundColor(.gray)
                                               .padding(.trailing)
                                       }
                                   }
                                   .padding(.top)

                                   ScrollView {
                                       LazyVGrid(columns: [GridItem(.adaptive(minimum: 180, maximum: 180), spacing: 20)], spacing: 30) {
                                           ForEach(backendService.ALbums, id: \.id) { album in
                                               AlbumCardView(playlist: album)
                                           }
                                       }
                                       .padding(.horizontal)
                                   }
                                   .padding(.top, 10)

                                                   }
                                                   .padding(.top, 10)
                                               }
                                           }
        .onAppear {
            backendService.fetchNewTracks()
            backendService.fetchTrendingTracks()
            backendService.fetchAlbums()
            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                trendingLabelOpacity = 1.0
            }
        }

                                       }
                                   }

struct OverviewView_Previews: PreviewProvider {
    static var musicViewModel = MusicViewModel()
    static var previews: some View {
        OverviewView()
            .environmentObject(musicViewModel)
    }
}

