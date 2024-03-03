# ER diagram

  [Country]                       [City]
+----+-------+               +----+-------------+
| PK | id    |  1      0..*  | PK | id          |
+----+-------+               +----+-------------+
|    | name  |  <---------   | FK | country_id  |
+----+-------+               +----+-------------+

=============================================================
# Database Schema
Country Table
+----+-------+
| id | name  |
+----+-------+
|  1 | USA   |
|  2 | Canada|
+----+-------+

City Table
+----+---------+------------+
| id | name    | country_id |
+----+---------+------------+
|  1 | New York| 1          |
|  2 | Toronto | 2          |
|  3 | Chicago | 1          |
+----+---------+------------+
=============================================================


# JPA entities
```java
@Entity
public class Country {

    @Id
    private int id;

    private String name;

    @OneToMany
    @JoinColumn(name = "country_id")
    private List<City> cities;
}

@Entity
public class City {

    @Id
    private int id;

    private String name;
}
```