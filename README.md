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

The front-end of this application is implemented by an Angular application and the back-end by a set of microservices implemented in Spring Boor or ASP.Net Core.

The commumication between client app and the microservices is throught Api Gateway and is carried out via API REST.

The communication across microservices is carried out asynchronously throught an event bus (RabbitMQ) and synchronously when is required through RESTful api.

The application has been deployed in Google Kubernetes Engine.

An overview of the system can be seen in the deployment diagram below.

![deploy](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/deploy_kubernetes.png)

**Final University Degree Project Spanish Report**
----------------

In the following link you can see a university report with the complete detail of an initial project design version:

[<img src="https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/Portada-TFG.PNG" width="50%">](https://drive.google.com/file/d/1n8LRlJwmtoOt1zs1OlBMOuQQwCfEsge5/view?usp=sharing)

**Demo**
----------------

The following video shows a demo of an application initial version and Google Kubernetes Engine(GKE) deploy details:

[<img src="https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/portada_demo.jpg" width="50%">](https://youtu.be/MIGo7PZA-PA)
