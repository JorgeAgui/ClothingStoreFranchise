# Design and integration of a polyglot cloud microservice-based application for the management of the needs of a clothing store franchise

**Project summary**
----------------

The objective of this software project is make an andvanced study of microservices architectures.

In order to put into practice the knowledge learned, the desgin and implementation of a microservice-based application has been carried out following the recommended good practices.

The result is a fault-resistant application that offers high availability and high scalability.

The front-end of this application is implemented by an Angular application and the back-end by a set of microservices implemented in Spring Boor or ASP.Net Core.

The commumication between client app and the microservices is throught Api Gateway and is carried out via API REST.

The communication across microservices is carried out asynchronously throught an event bus.

The application has been deployed in Google Kubernetes Engine.

An overview of the system can be seen in the deployment diagram below.

![deploy](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/deploy_kubernetes.png)

**Final Degree Project spanish report**

In the following link you can see a university report with the complete detail of an initial project design version:

[<img src="https://i.ytimg.com/vi/Hc79sDi3f0U/maxresdefault.jpg" width="50%">](https://www.youtube.com/watch?v=Hc79sDi3f0U "Now in Android: 55")

**Implementation**
----------------

In order to isolate the development of each microservice, a repository has been created for each microservice. This repositories have been grouped in a GitHub organization that you can find in the following link.

- [ClothingStoreFranchise](https://github.com/ClothingStoreFranchise)
