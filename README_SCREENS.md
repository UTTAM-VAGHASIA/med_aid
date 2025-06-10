# MED-AID App New Screens

This README describes the new screens added to the MED-AID app.

## Equipment List Screen

The Equipment List screen displays medical equipment available through the app. Features include:

- Teal header with app logo and settings button
- Search bar for filtering equipment
- Grid layout of equipment cards with images
- Each card shows the equipment name and image
- Equipment items include: Hospital bed, Walking stick, Crutches, Walker, Wheel chair, Stretcher, Coller, Nebulizer, and Pulse oximeter

## NGO List Screen

The NGO List screen displays charitable organizations that partner with MED-AID. Features include:

- Teal header with app logo and settings button
- Search bar for filtering NGOs
- List of NGO cards with detailed information
- Each card shows:
  - NGO name and logo
  - Location and opening hours
  - Organization type
  - Contact information (phone number)
  - Address with location icon

## Navigation

Both screens are accessible from the Home screen via dedicated buttons. The app router has been updated to include these new screens with proper transitions.

## Implementation Details

- Both screens use GetX for state management
- Controllers handle data loading and search functionality
- UI follows the app's design language with teal as the primary color
- Status bar color matches the header for a seamless look 