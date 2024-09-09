# <p align="center">ShopMatic</p>

## Overview

**ShopMatic** is a Flutter app designed for managing and generating product variants based on user-defined options and values. Users can add product options (e.g., size, color), specify their values, and generate all possible variants. The app focuses on providing an intuitive UI for option management and variant generation without backend integration.

## Features

- **Add Product Options:** Users can input option names and their respective values.
- **Generate Variants:** Based on the provided options and values, the app generates all possible variants.
- **User-Friendly Interface:** The app provides a straightforward and intuitive UI for managing product options and variants.

## Key Highlights

- **Dynamic Option Input:** Users can dynamically add multiple options and values.
- **Variant Generation Logic:** The app includes logic to generate all possible combinations of options and values to create product variants.
- **Responsive Design:** The UI adapts to various screen sizes, ensuring a smooth user experience on both phones and tablets.

## State Management

The project uses the default state management provided by Flutter. While this is suitable for demonstrating basic functionality, the app can be further improved by incorporating more advanced state management solutions like Provider, Riverpod, or Bloc for better scalability and maintainability.

## Screenshots

<p align = "center">
<img src = "https://github.com/user-attachments/assets/f55bcbe2-9c94-46bc-9b5e-923f2280dd7f" width = "30%" height = "30%" />
<img src = "https://github.com/user-attachments/assets/c9c5833d-2c3b-4ecd-8364-233110fed907" width = "30%" height = "30%" />
<video width = "200" height = "150" controls> 
<source src = "https://drive.google.com/file/d/1aCMQJW-HMdjVpRgM-K5-gGB1bNnWyr-E/view?usp=sharing" type = "video/mp4" />
Your browser does not support the video tag.
</video>
</p>

## Installation

1. Clone the repository:
   
   ```bash
   git clone https://github.com/DenisGithuku/ShopMatic.git
   ```

2. Navigate to the project directory:
   
   ```bash
   cd ShopMatic
   ```

3. Install the dependencies:
   
   ```bash
   flutter pub get
   ```

4. Run the app:
   
   ```bash
   flutter run
   ```

## Code Structure

- **lib/screens**: Contains the main screens of the app.
  
  - **lib/screens/new_product**: Contains components and logic specific to the new product screen.
    - **components**: Reusable widgets for product options and variants, such as input fields, option sections, and the variants table.
      - `variants_table.dart`: Displays the generated product variants.
      - `product_item.dart`: Represents a single product item.
      - `options_section.dart`: Manages the section where options are added.
      - `option_value_input.dart`: Input field for entering option values.
      - `option_chips_section.dart`: Displays option values as chips.
      - `user_input_field.dart`: A generic user input field.
      - `options_header.dart`: Header for the options section.
      - `image_widget.dart`: Widget for displaying images.
      - `add_option_button.dart`: Button for adding new options.
    - `new_product.dart`: The main screen for adding a new product and managing its options and variants.
  - `home.dart`: The home screen of the app.

- **lib/repository**: Contains the repository for managing product data.
  
  - `product_repository.dart`: Manages interactions with data sources.

- **lib/data**: Contains data-related files, including models and database interactions.
  
  - `product_db.dart`: Handles the database logic for product data.
  - `model.dart`: Defines the data models used in the app.

- **lib**:
  
  - `main.dart`: Entry point of the application.
  - `colors.dart`: Defines color constants used throughout the app.

## Dependencies

The following dependencies are used in this project:

- **flutter**: The SDK for building cross-platform apps.
- **cupertino_icons**: Provides icons for iOS-styled apps.
- **sqflite**: A SQLite plugin for Flutter for local database storage.
- **path**: A library for manipulating file system paths.
- **image_picker**: A Flutter plugin for selecting images from the gallery or camera.
- **permission_handler**: A plugin for managing permissions in a Flutter app.

### Development Dependencies

- **flutter_test**: A package for testing Flutter apps.
- **flutter_lints**: Provides lints for Flutter projects.
- **flutter_launcher_icons**: A package for generating app launcher icons.

## Usage

1. Launch the app.
2. Use the interface to add product options and values.
3. Tap the button to generate variants based on the entered options.
