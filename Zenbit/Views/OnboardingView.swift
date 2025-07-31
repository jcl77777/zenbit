import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentStep = 0
    
    var body: some View {
        Group {
            if currentStep == 0 {
                WelcomeView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .onAppear {
                        // 延遲一下再進入下一步
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                currentStep = 1
                            }
                        }
                    }
            } else {
                FirstTimeSetupView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
        .animation(.easeInOut, value: currentStep)
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
} 