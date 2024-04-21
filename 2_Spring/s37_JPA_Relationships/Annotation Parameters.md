@OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)

@JoinColumn(name = "user_id", nullable = false)


@Id
@GeneratedValue(strategy = GenerationType.IDENTITY) //necessary if you want the database to automatically generate primary key values for new entities. This annotation is particularly important for entities like Tweet where you might not manually set the primary key value when creating a new instance.
private long id;