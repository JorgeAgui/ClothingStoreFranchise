# ClothingStoreFranchise

**Resumen del Proyecto**
----------------

El objetivo de este proyecto de software es realizar un estudio avanzado sobre las arquitecturas de microservicios. Para poner en práctica los conocimientos aprendidos se ha realizado el diseño e implementación de una aplicación basada en esta arquitectura para gestionar una tienda de ropa ficticía. Se han seguido las buenas prácticas que exigen este tipo de arquitectura.

Se trata de una aplicación cloud poliglota basada en una arquitectura de microservicios para dar una solución tecnológica al negocio de una franquícia de tiendas de ropa.

El front end de esta aplicación esta implementado por una aplicación angular y el back end por un conjunto de microservicios implementados en Spring Boot o en ASP.Net Core. 

La comunicación entre la aplicación cliente y los microservicios es a través de la API Gateway como punto de entrada y se efectúa mediante API REST.

La comunicación entre microservicios se realiza salvo casos excepcionales de forma asíncrona mediante un bus de eventos.

La aplicación ha sido desplegada en contenedores docker.

En el diagrama de despliegue siguiente se puede ver una visión global del sistema.

![deploy](https://github.com/JorgeAgui/ClothingStoreFranchise/tree/spanish/figures/deploy.png)

**Contexto**
----------------

La franquicia de ropa ficticia Clothing My World esta siendo un éxito en el mercado de la moda en los últimos meses. Socios e inversores prevén un incremento en el negocio enorme, por lo que deciden invertir en un software que permita gestionar la totalidad del negocio de forma eficiente y que pueda escalar al mismo ritmo que lo hará el negocio. Este software tendrá un papel fundamental en el funcionamiento del negocio y se estima que la cantidad de clientes y empleados será muy elevada, así que se necesitará una aplicación con una alta disponibilidad y resistente a fallos, que evite grandes perdidas económicas por caídas del sistema.

Se desea que el software ofrezca servicios de tienda online, gestión de productos, stocks, tiendas, almacenes, ventas físicas, ventas online, repartos, proveedores...

Con el fin de satisfacer las necesidades requeridas por el negocio, se ha diseñado e implementado una aplicación cloud políglota basada en una arquitectura de microservicios. Este tipo de arquitectura ha sido bastante utilizada de forma exitosa en los últimos años para diseñar aplicaciones con este tipo de requisitos, debido a que ofrece un sistema resistente, con una alta disponibilidad y una gran escalabilidad.
