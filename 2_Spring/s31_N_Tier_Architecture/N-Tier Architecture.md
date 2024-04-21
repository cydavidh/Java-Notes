The presentation layer handles the interface that is displayed to the user.

The business layer implements rules for handling the problem your application was designed to solve.

The persistence layer contains database storage logic and handles the translation of objects into database formats.

The database layer contains the actual database storage system and handles tables, indices, and any database-related operations.




Presentation: UserController(injects userService)
Business: User(domain object) and UserService(injects repository)
Persistence: UserRepository(crud repository)
Database: oracle, h2
