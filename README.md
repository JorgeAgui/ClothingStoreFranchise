# Sistema basado en arquitectura de microservicios. Implementación de una aplicación cloud políglota.

**Resumen del Proyecto**
----------------

El objetivo de este proyecto de software es realizar un estudio avanzado sobre las arquitecturas de microservicios. Con el fin de poner en práctica los conocimientos aprendidos, se ha realizado el diseño e implementación de una aplicación basada en este tipo de arquitectura siguiendo las buenas prácticas recomendadas.

El resultado es una aplicación resistente a fallos, que ofrece una alta disponibilidad y una alta escalabilidad.

El front end de esta aplicación esta implementado por una aplicación Angular y el back end por un conjunto de microservicios implementados en Spring Boot o en ASP.Net Core. 

La comunicación entre la aplicación cliente y los microservicios es a través de la API Gateway como punto de entrada y se efectúa mediante API REST.

La comunicación entre microservicios se realiza salvo casos excepcionales de forma asíncrona mediante un bus de eventos.

La aplicación ha sido desplegada en Google Kubernetes Engine.

En el diagrama de despliegue siguiente se puede ver una visión global del sistema.

![deploy](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/deploy_kubernetes.png)

**Implementación**
----------------

Con el fin de aislar el desarrollo de cada microservicio se ha creado un repositorio por cada microservicio. Estos repositorios se han agrupado en una organización que se encuentra en el siguiente enlace.

- [ClothingStoreFranchise](https://github.com/ClothingStoreFranchise)
