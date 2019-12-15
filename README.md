## Problem
### Technical requirements
1. Use the latest stable Rails version
2. Use Slim view engine
3. Frontend Framework (optional)
    - React JS
    - Angular
4. Cover all changes with Rspec tests
5. Add integration tests via Capybara
6. Create factories with FactoryBot
7. Apply Rubocop and other linters
8. For Rails models try to use:
    - STI
    - Scopes
    - Validations and custom validator object, if necessary
    - Factory pattern
    - Demonstrate meta-programming by generating/defining similar predicate
methods
    - Encapsulate some logic in a module
    - Have class methods
    - Have a private section
9. For Rails controllers try to:  
    - Keep them 'thin'
    - Encapsulate business logic in service objects, use cases, or similar
operations, interactors
10. Presentation:
    - Use partials
    - Define Presenters (View models, Form objects (5))
11. Try to showcase background and cron jobs

### Task
Create a mock payment system:
1. Relations:
    - Merchants have many payment transactions of different types
    - Transactions are related (belongs_to)
    - You can also have follow/referenced transactions that refer/depend to/on
the initial transaction
    - Example:
        - Initial Transaction -> Settlement (Charge) Transaction -> Refund
Transaction
        - Initial Transaction -> Invalidation (Cancel) Transaction
    - Destroys all transactions, if merchant is deleted
    - Has merchant and admin user roles (UI) (optional)

2. Model fields:
    - Merchant: name, description, email, status (active, inactive), total
transaction sum (of all transactions)
    - Transaction: UUID, amount, status (processed, error)

3. Inputs and tasks:
    - Accepts payments using XML/JSON API (single point POST request)
    - Include API authentication layer (basic auth, Token-based etc)
    - Imports new merchants from CSV (rake task)
    - Has background job deleting transactions older than an hour (cron job)
4. Presentation:
    - Display, edit, destroy merchants
    - Display transactions

## Implementation

### How to run
```shell script
bundle exec rails s
```

### Decisions desctription

#### Business logic implementation

##### Approach
A fin-tech application is described in the task. This sort of application tends to grow rapidly.  
Domain described in the task as a composition of relatively small independent entities.  
So it is a rich domain. And normally I'd prefer to implement it using the [Domain Model](https://martinfowler.com/eaaCatalog/domainModel.html) approach.  
Meanwhile, in fact, this application isn't going to have a long lifecycle. And current logic is relatively simple. So, it could be fine to use [Transaction Script](https://martinfowler.com/eaaCatalog/transactionScript.html) as well.  
The domain model approach requires additional resources for implementation compared to the transaction script. But it worth it in long terms.  
After all, I decided to implement a domain model to illustrate my skills.

Because of the simplicity of the domain, it doesn't make sense to extract the [Service Layer](https://martinfowler.com/eaaCatalog/serviceLayer.html)

##### 1. Domain model implementation

According to the task, we can define two entities: Merchant and Transaction.  
Since transaction makes no sense without a merchant it seems like a good idea to join them in the [aggregate](https://martinfowler.com/bliki/DDD_Aggregate.html).  
And merchant should be an aggregation root.  
There are two main related operations:
- Create a transaction
- Destroy all transaction older than 1 hour

According to the principles of [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html), we should avoid using a framework on the domain model level.  
In particular, rails' implementation of the [Active Record pattern](https://www.martinfowler.com/eaaCatalog/activeRecord.html) lacks encapsulation. And Transactions must be immutable by their essence.  
But since our entities are pretty simple and there won't be many teams working with this project, it's a kind of compromise to break this rule and use AR directly. As a benefit, we'll increase development speed.  
Otherwise, I'd use plain objects as entities and AR as a mechanism to implement database mapping (i.e. like [Row Data Gateway](https://martinfowler.com/eaaCatalog/rowDataGateway.html)).  

The creation of transaction assumes changing of Merchant's balance. And that's the example of invariant which will be preserved by the aggregate.  
  
For now, it is not clear whether 1 hour is a constant life span for transactions or it can be somehow changed.  
That's why I've decided not to accept it as a parameter.  
In this way, we prevented the leaking of business logic from the layer.  
But we'll be able to introduce this parameter easy if we need it in the future.   

For Merchant, we can use email as an identifier. UUID is an identifier of transactions.  
But I've left IDs for these entities for more convenient database mapping.  

**Validations**
The domain model must provide invariant. It means we can't rely on incoming data.
AR provides a great API for validation. But to use it we have to create a potentially invalid object or turn the existed one into an invalid state.  
That's because it is designed for data-centric applications. Domain model I'm going to use manual validation.  
And for better expressiveness, I'll implement a result object which is a kind of crosscutting concept.   


**Specs**  
To avoid [Primitive Obsession](https://refactoring.guru/smells/primitive-obsession) and [Long Parameter List](https://refactoring.guru/smells/long-parameter-list) a merchant accepts a [DTO](https://martinfowler.com/eaaCatalog/dataTransferObject.html) instead of hash o plain values.  
We don't need such a sort of DTO to be implemented in the domain layer. That's why I've used double in specs and fixed its contract.  
