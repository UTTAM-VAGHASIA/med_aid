# MED-AID App - Updated Navigation Flow

## New Navigation Flow

The navigation flow in MED-AID has been updated to provide a streamlined user experience:

1. **Splash Screen** → **City Selection Screen**
   - When the app starts, users see a splash screen with the MED-AID logo
   - After animations complete, they're taken directly to the City Selection screen

2. **City Selection Screen** → **Equipment List Screen**
   - After selecting a city and tapping "Submit"
   - Users are taken directly to the Equipment List screen

3. **Equipment List Screen** → **NGO List Screen**
   - When a user taps on any equipment item
   - They're taken to the NGO List screen showing organizations that can provide that equipment

## Key Changes Made

1. Updated the City Selection screen's submit button to navigate to Equipment screen instead of Home screen
2. Added tap functionality to Equipment items to navigate to NGO list
3. Modified the Splash screen to start at City Selection instead of auth/home
4. Updated app router redirects to maintain the new navigation flow
5. Removed Home screen from the main navigation path

## Technical Implementation

- Navigation is handled through GoRouter with custom transitions
- The AppRouter class provides the `goWithTransition()` method for smooth transitions
- GetX is used for state management and dependency injection
- Each screen uses proper bindings to ensure controllers are available 