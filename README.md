# Design and integration of a polyglot cloud microservice-based application for the management of the needs of a clothing store franchise

**Poject GitHub organization**
----------------

In order to isolate the development of each microservice, a repository has been created for each microservice. This repositories have been grouped in a GitHub organization that you can find in the following link.

- [ClothingStoreFranchise](https://github.com/ClothingStoreFranchise)

**Project summary**
----------------

The objective of this software project is make an andvanced study of microservices architectures.

In order to put into practice the knowledge learned, the desgin and implementation of a microservice-based application has been carried out following the recommended good practices.

The result is a fault-resistant application that offers high availability and high scalability.

The front-end of this application is implemented by an Angular application and the back-end by a set of microservices implemented in Spring Boot or ASP.Net Core.

The communication between client app and the microservices is through Api Gateway and is carried out via API REST.

The communication across microservices is carried out asynchronously through an event bus (RabbitMQ) and synchronously when is required through the RESTful api.

The application has been deployed in Google Kubernetes Engine.

An overview of the system can be seen in the deployment diagram below.

![deploy](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/deploy_kubernetes.png)

**Final University Degree Project Spanish Report**
----------------

In the following link you can see a university report with the complete detail of an initial project design version:

[<img src="https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/Portada-TFG.PNG" width="50%">](https://drive.google.com/file/d/1n8LRlJwmtoOt1zs1OlBMOuQQwCfEsge5/view?usp=sharing)

**Demo**
----------------

The following video shows a demo of an application´s initial version and Google Kubernetes Engine(GKE) deploy details:

[<img src="https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/portada_demo.jpg" width="50%">](https://youtu.be/MIGo7PZA-PA)

**Domain-Driven Design (DDD)**
----------------

To design of the microservice-based architecture that will be used to application implementation, DDD has been applied and a microservice defined. Once studied and applied this software design approach with the support of the information get during the analysis phase, the domain model has been fragmented into subdomains that define the following microservices:

-	Authentication microservice: is in charge of managing the storage and authentication of the system users, generating JWTs (JSON Web Tokens).  
-	Customers microservice: is in charge of managing clients registered in the system and their shopping carts.
-	Catalog microservice: is in charge of managing catalog product categories and offers.
-	Inventory microservice: is in charge of managing shop and warehouse products inventory.
-	Employees microservice: is in charge of managing employees registered in the system.
-	Sales microservice: is in charge of managing online and physical shop sales.
The following figure shows the system domain model fragmented in subdomains after applying DDD. Each subdomain represents a Microservice model.
![fomainDesign](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/micro-domains.png)

In the figure above can be seen in the domain model in design that there are replicated classes in different subdomains, for example, the Product class of Microservice Inventory depends on the Product class of Microservice Catalog. These classes represent a Product in different organization parts, the Catalog, and the Inventory. Each of them contains the necessary information to satisfy the microservice functionality in which the class is located.

Break an application into microservices involves several challenges that must be faced:
-	Network latency due to microservices coupling.
-	Decreased availability due to synchronous inter-microservice communication, if a microservice goes down then all microservices that depend on it, and their functionality will be affected.
-	Keep up tha data consistency through microservices, each microservice will have its own database and will not be allowed to access another microservice database.
-	Consistent data in a system where there is no centralized database.

**Resiliency and high availability**
----------------
Dealing with unexpected failures is one of the most challenging  problems, especially in a distributed system.
A microservice needs to be resilient to failures and to be able to restart often on another machine for availability. If a service fails or is restarted, no system data loss should occur and this data must stay consistent.

A cloud system must be fault tolerant and to try automatically recover from them. For example, in the event of a network failure, the client apps or the client services must have a recovery strategy: forwarding messages, retying requests...

Container microservices deployment allows easily create of microservice replicas to avoid resource overload problems. 

These features have been kept in mind when designing this architecture microservice-based system.

**API Gateway design**
----------------

The API Gateway provides customers a single system entry point. Its main function principal function is to manage the microservices input traffic through request routing and filtering, although it can also implement other functionalities. Also, the API Gateway can perform the function of a protocols translator, for example, communicate with the application outside via REST API and with the application inside via gRPC. In the case of the application developed in this project the external and internal API Gateway communication is via API RESTful.
The following figure shows the routed design that the API Gateway performs to microservices.
![apiGateway](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/api-gateway.png)
The API Gateway is composed of a Service Discovery, a Load Balancer and a Circuit braker that complements its functionality.

**Data consistence in microservice-based architecture**
----------------

Each microservice system has its own database. The database stored data are private and can just be accessed via microservice APIs. This is a challenge when implementing end-to-end business processes while data consistency is maintained through multiple microservices.

Taking as an example the developed application, the microservice Catalog contains all products. The microservice Inventory manages temporal data about product stock in shops and warehouses. When the product price is changed in the Inventory microservice, this price also must be changed in the Catalog microservice.

In a hypothetical monolithic version, a product catalog updated will be an immediate transaction in the ProductInventory table.

However, in a microservice-based application, the ProductCatalog table and the ProductInventory table are the property of their respective services. No microservice can never directly access another microservice database via queries, as it is shown in the following figure.
![privateDatabases](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/privateDatabases.png)

Catalog microservice must not update InventoryProduct table directly. To update the Inventory microservice, the microservice Catalog will use a future consistency type based on asynchronous inter-microservice communication by events integration (communication-based on messages and events), as designed in this application.

In most scenarios where microservice-based architecture is used, high availability and high scalability are demanded, sacrificing high consistency in return. These systems must be developed using techniques that allow you to work with weak consistency.

The challenge of maintaininig data consitency between microservices, is directly related with the question of how to propagate changes through multiple microservices when certain data need to be replicated in those microservices that need it. For example, when it is necessary to have the same name in Catalog microservice and Inventory microservice.

The solution that has been used to resolve this problem is to use future consistency techniques, implementing the Event-Driven pattern (asynchronous communication managed by events) and implementing a Publish/Subscribe system.

**Inter-microservice communication design**
----------------

One of the great challenges of microservice-based architecture is the inter-microservice communication. When designing, the different communication styles must be analyzed according to the coupling level that the microservices must have. Depending of coupling level, when a fault occurs, the system impact will vary significantly. 

Microservice-based architecture systems, are distributed in multiple services housed in different servers. This services may fault, producing partial failures or major failures that would critically affect the entire system.

One of the most popular approaches due to its simplicity is to implement synchronous inter-microservice communication baes on REST APIs, as shown in the following figure.
![deploy](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/syncCommunication.png)
This approach can be problematic when we create inter-microservice synchronous HTTP request long strings:
-	Locks between microservices and high latencies. Due to HTTP synchronous nature, the original request will not get response until all internal requests have finished. This would have a negative impact on application performance that would worsen as the application scales.
-	Couple between microservices with HTTP. Microservice business services must not be coupled to other microservice business service. Ideally, a microservice must not know other microservice existence.
-	Mantain data consistency through microservices, each microservice will have its own storage database and will not be able to access another database microservice.
-	Failures in any other service. In a microservices chain linked by HTTP requests, when  Fallos any microservice in the chan fails, then all microservice in the chain will fail.

Inter-microservice communication has been designed in such a way that the microservices perform their functions as autonomously and independently as possible, de tal modo que los microservicios realicen sus funciones de la forma más autónoma e independiente posible, reducing as much as possible inter-microservice communication. For it, inter-microservice communication has been implemented mostly asynchronously as shown in the figure, Following design pattern and using communication protocols that will be discussed below.
![deploy](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/asyncCommunication.png)

**Communication protocols**
----------------

Application inter-microservice communication design made is aimed at reducing the amount of inter-service communications as much as possible and to propagate the data asynchronously. But in some cases there may be a need for synchronous inter-service communication. Two protocols types have been implemented in this application:

-	HTTP (Hypertext Transfer Protocol): allow synchronous request/response communication. It will be implemented as APIs REST and its main use will be the communication between client and microservices via API Gateway. This protocol is ideal when the client must be receive a response asynchronously. Also this protocol is used on inter-microservice communication when a microservice needs a synchronous response o another microservice.
-	AMQP (Advanced Message Queuing Protocol): allow synchronous and asynchronous request/response communication, in addition to be design to be used in a publish/subcribe system. This protocol is implemented through an event bus. It is the main protocol inter-microservice communication due to its asynchronous communication type is perfect in a publish/subscribe system, which make it ideal for spreading data between microservices.
Although implementin a event bus supported by AMQP is more versatile by allowing a greater number of communication methods, in addition to the possibility of persisting messages, implementing a RESTful APIs supported by HTTP is much simpler and requires a much smaller learning curve than implementing an event bus.

**Asynchronous communication based on messages**
----------------
The model entities like Product, Warehouse, Shop... can have different meanings in different microservices. This means that certain data of replicated entities by microservices must be updated by the microservice that owns the information.
The solution that has been implemented to propagate the changes through multiple microservices is eventual data consistency and event-driven communication through asynchronous messages.
When using messaging, the process communicates by exchanging messages asynchronously. The client sends a request sending a message, if the server needs to respond to the client then it sends a different response message to the client. The client assumes that the response will not be immediate or that will not receive a response. 
A message is composed of a head and a body. The messages are sent by AMQP protocol.
In an event-driven communication, a microservice publish events in a event bus whenever something changes in its domain, and various microservices subscribe to these events to be asynchronously notified whenever a publication of said events is made. This publish/subscribe system has been implemented using an event bus.

**Simplified Event Sourcing**
----------------

When events are published through a distributed messaging system as an event bus, exists the problem of updating atomically the microservice database and publishing the event. The case must be avoided where for some reason there is a failure to persist the data in the microservice database and this data is published in the event bus or vice versa. This event would leave the system in an inconsistent state.

The solution that has been implemented is a simplification of the Event Sourcing pattern combined with a transactional database table. Statuses have been used in the events, for example, "ready to publish", these events are stored in a table called IntegrationEventLog and their status will be updated as it progresses through its phases from when the event is created until it is published.

The following figure shows the IntegrationEventLog table design.
![integrationEventDB](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/integrationEventDB.png )

Each microservice has its own IntegrationEventLog table in its relational database. This table works as a backup to achieve atomicity, so that events in the same transactions are persisted as the domain data is persisted.

If an event publication fails, the data will not be inconsistent, due to the event will remain in the IntegrationEventLog table with the state "ready to post". This event will be retried to post when the microservice or event bus is restarted.

With this approach, the events will be stored in the table IntegrationEventLog only in the microservices that will publish the event (event-producing microservices).

**Communication diagrams**
----------------
In this section will be explained in a summarized way and with sequence diagrams help as an example, the design of inter-microservice communication that has been made.
-	Publish/Subscribe:
The asynchronous messaging pattern that has been used to broadcast changes in the domain data in the microservices in which these data are replicated.

The microservice Publisher publishes an event in the message broker with a send and forgot philosophy. The microservices subscribed to this event (Subscribers) will receive the event data asynchronously. The Publisher microservice is the owner of the data that publishes, these data must not be modified by any Subscriber microservice. The following sequence diagrams show how communications have been designed for the application using this pattern.
![CreateProductEvent](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/CreateProductEvent.png )

![UpdateWarehouseEvent](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/UpdateWarehouseEvent.png )

![UpdateStockEvent](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/UpdateStockEvent.png )
-	Request/Response asíncrono:
Point-to-point communication method. The client microservice sends a resquest that is received by the server microservice asynchronously, the server microservice processes the request and sends a response to the client that will also be received asynchronously.
![UpdateStockEvent](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/ValidateOrderEvent.png )

**Authentication system design**
----------------
The user accounts are owned by the system and the authentication through the microservices is done using (JSON Web Token). 
In order to have greater flexibility and control in the authentication process has been implemented an own authentication microservice. This microservice has its main function to manage the authentication system, generating access tokens that will propagate the user identity and privileges through of the microservices. 
In order to ensure the system security the generated access tokens by authentication microservices are signed and encoded, this has been done following the following standards:
-	JSON Web Signature (JWS): standard defined in RFC 7515. JWS is used to digitally sign an access token,  it is a way to ensure highly serializable information integrity with the certainty that said information has not been modified since the token was signed. Token information can be read by a simple Base64 decoder. The token signature has been done with the asymetric alogirithm RS256 using a public key.
-	JSON Web Encryption (JWE): standard defined in 7516. JWE is used to encode an access token, this token is completely opaque to the client that uses it as a way of athentication and authorization. The token encryption has been done with the algorithm HS256 using a private key.
The following figure shows a visual representation of the authentication system.
![authentication](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/authentication.png )

When the client sign in, the authentication microservice generate a signed and encrypted token that is temporarily stored in the client application. When the client application makes any backend request, this access token will be sent in the http request header. The API Gateway decodes and validates the encrypted token (JWE), if everything is correct, routed the request with the signed token (JWS) to the corresponding microservice where it will also be validated.
