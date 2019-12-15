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
