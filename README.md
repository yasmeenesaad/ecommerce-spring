# E-Commerce Spring Project

This is a full-featured e-commerce web application built using Spring Framework. The project provides functionalities for managing products, customers, orders, and a shopping cart, with integrated security features.

## Table of Contents

- [Features](#features)
- [Entity-Relationship Diagram](#ERD)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Project Structure](#project-structure)
- [Contributing](#contributing)

# Features

- User registration and authentication
- Product catalog with search and filter capabilities
- Shopping cart functionality
- Order management and checkout process
- Admin dashboard for managing products and orders
- Payment gateway integration (e.g., PayPal, Stripe)
- Responsive design with Bootstrap
- RESTful API endpoints for front-end communication
- Password encryption for enhanced security
- Third-party login options using Google, Facebook, and GitHub


# ERD
![ERD](chicly-erd.png)

## Technologies Used

- **Backend**: Spring Framework, Spring Boot, Spring Security
- **Persistence**: Hibernate/JPA, MySQL
- **Frontend**: Thymeleaf, Bootstrap, JavaScript, jQuery
- **Build Tool**: Maven
- **Version Control**: Git
- **Other Tools**: Lombok, JWT (for authentication)

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mohab-wahdan/ecommerce-spring.git
   
   cd ecommerce-spring
# Database Configuration

Follow these steps to set up the database for this project:

## 1. Create the Database
- Create a MySQL database named `chicly`.

## 2. Update the Application Properties
- Open the `application.properties` or `application.yml` file located in the `src/main/resources` directory.
- Update the file with your database connection details (username and password).

### Example configuration for `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/chicly

spring.datasource.username=your_username

spring.datasource.password=your_password
```
# Build and Run the Project

Follow these steps to build and run the application:

## 1. Build the Project
Use the following command to clean and build the project:

```bash
mvn clean install
```

# Build and Run the Project

Follow these steps to build and run the application:

## 1. Build the Project
Use the following command to clean and build the project:

```bash
mvn clean install
```
## 2. Run the Application
Start the application using the command:

```bash
mvn spring-boot:run
```
## 3. Access the Application
Once the application is running, navigate to the following URL in your web browser:
http://localhost:8083

# Usage

## User Actions
- Register and log in to the system.
- Browse and search for products.
- Add products to the shopping cart and proceed to checkout.
- View order history.

## Admin Actions
- Log in to the admin dashboard.
- Manage products, categories, and orders.

# Configuration

## Spring Security Configuration
- Modern Spring Security configuration without `WebSecurityConfigurerAdapter`.
- JWT is used for securing the API.

## Database Configuration
- Uses MySQL with Hibernate as the JPA provider.

## Properties Configuration
- Configuration files are located in the `src/main/resources` directory.

# Project Structure

The project follows a standard Spring Boot structure:
```
ecommerce-spring/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── example/
│   │   │           └── ecommerce/
│   │   │               ├── controllers/        # Handles HTTP requests and responses
│   │   │               ├── dtos/               # Data Transfer Objects for data exchange
│   │   │               ├── enums/              # Custom enumeration types
│   │   │               ├── exceptions/          # Custom exception handling classes
│   │   │               ├── mappers/            # Mappers for converting between DTOs and models
│   │   │               ├── models/             # Domain model classes representing entities
│   │   │               ├── repositories/        # Repository interfaces and implementations
│   │   │               ├── security/            # Security configurations and authentication classes
│   │   │               ├── services/            # Service classes encapsulating business logic
│   │   │               ├── thirdParty/          # Classes for interacting with third-party services
│   │   │               └── util/               # Utility classes for common functions
│   │   ├── resources/
│   │   │   ├── static/                            # Static resources (CSS, JavaScript, images)
│   │   │   ├── templates/                         # Templates for dynamic content (e.g., Thymeleaf)
│   │   │   └── application.properties             # Configuration properties for the application
│   └── test/                                     # Test classes for unit and integration testing
├── webapp/                                       # Web resources for the web application
├── target/                                       # Build artifacts generated by the build system
├── pom.xml                                       # Maven project configuration file
└── README.md                                     # Project documentation
```
# Contributing

Contributions are welcome! If you would like to contribute to this project, please follow these steps:

1.  **Fork the repository.**
   
2.  **Create a new branch:**
   ```bash
   git checkout -b feature-branch
   ```
3. Make your changes and commit them:
```bash
git commit -m 'Add some feature'
```
4. Push to the branch:
```bash
git push origin feature-branch
```
5. Submit a pull request.

## Contributors

This project was developed with the help of the following contributors:

| Name                   | Email                        |
|------------------------|------------------------------|
| Mohab Wahdan           | mohabmostafa176@gmail.com    |
| Yasmeen saad           | yasmeenesaad@gmail.com       |
| Mohammed Ashraf        | mohamedashraf14526@gmail.com |
| Waleed Kamal           | waleedkamal1999@gmail.com    |
| Nourhan ELsherbiny     | nouraelsherbiny98@gmail.com  |

Feel free to reach out to any of the contributors for more information about the project.