# ClothingStoreFranchise

**Resumen del Proyecto**
----------------

El objetivo de este proyecto de software es realizar un estudio avanzado sobre las arquitecturas de microservicios. Para poner en práctica los conocimientos aprendidos se ha realizado el diseño e implementación de una aplicación basada en esta arquitectura para gestionar una tienda de ropa ficticia. Se han seguido las buenas prácticas que exigen este tipo de arquitectura.

Se trata de una aplicación cloud poliglota basada en una arquitectura de microservicios para dar una solución tecnológica al negocio de una franquicia de tiendas de ropa.

El front end de esta aplicación esta implementado por una aplicación Angular y el back end por un conjunto de microservicios implementados en Spring Boot o en ASP.Net Core. 

La comunicación entre la aplicación cliente y los microservicios es a través de la API Gateway como punto de entrada y se efectúa mediante API REST.

La comunicación entre microservicios se realiza salvo casos excepcionales de forma asíncrona mediante un bus de eventos.

La aplicación ha sido desplegada en contenedores docker.

En el diagrama de despliegue siguiente se puede ver una visión global del sistema.

![deploy](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/deploy.png)

**Contexto**
----------------

La franquicia de ropa ficticia Clothing My World está siendo un éxito en el mercado de la moda en los últimos meses. Socios e inversores prevén un incremento en el negocio enorme, por lo que deciden invertir en un software que permita gestionar la totalidad del negocio de forma eficiente y que pueda escalar al mismo ritmo que lo hará el negocio. Este software tendrá un papel fundamental en el funcionamiento del negocio y se estima que la cantidad de clientes y empleados será muy elevada, así que se necesitará una aplicación con una alta disponibilidad y resistente a fallos, que evite grandes pérdidas económicas por caídas del sistema.

Se desea que el software ofrezca servicios de tienda online, gestión de productos, stocks, tiendas, almacenes, ventas físicas, ventas online, repartos, proveedores...

Con el fin de satisfacer las necesidades requeridas por el negocio, se ha diseñado e implementado una aplicación cloud políglota basada en una arquitectura de microservicios. Este tipo de arquitectura ha sido bastante utilizada de forma exitosa en los últimos años para diseñar aplicaciones con este tipo de requisitos, debido a que ofrece un sistema resistente, con una alta disponibilidad y una gran escalabilidad.
**Diseño guiado por el Dominio (DDD)**
----------------
Para realizar el diseño del dominio de la arquitectura de microservicios que se utilizará para la implementación de la aplicación que se realizará en este trabajo, se ha aplicado DDD y definido un microservicio por cada subdominio. Una vez estudiada y aplicada esta técnica con el apoyo de la información  obtenida durante la fase de análisis, se ha desglosado el modelo de dominio en subdominios que representan a los siguientes microservicios:

-	Microservicio Authentication: se encargará de gestionar el almacenamiento y autenticación de los usuarios del sistema generando JWTs (JSON Web Tokens). 
-	Microservicio Customers: se encargará de gestionar los clientes registrados en el sistema y su carro de la compra.
-	Microservicio \textit{Catalog}: se encargará de la gestión de los productos del catálogo, de sus categorías y ofertas.
-	Microservicio  Inventory: se encargará de la gestión del inventario de productos en tiendas y alamcenes.
-	Microservicio Employees: se encargará de la gestión de los empleados registrado en el sistema.
-	Microservicio Sales: se encargará de la gestión de las ventas online y en tiendas físicas.
En la figura siguiente se muestra el modelo de dominio del sistema desglosado en subdominios tras aplicar DDD. Cada subdominio representa el modelo de cada Microservicio que formará el sistema.
![fomainDesign](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/micro-domains.png)

Se puede ver en el modelo de dominio en diseño Figura 4.1 que hay clases que están replicadas en
subdominios distintos, como por ejemplo, la clase Producto del Microservicio Inventory que depende de la clase Producto del Microservicio Catalog. Estas clases representan a un Producto en una parte de la organización diferente, el Catálogo y el Inventario. Cada una de ellas contiene la información necesaria para satisfacer las necesidades de la funcionalidad del Microservicio en el que se encuentra.
Descomponer una aplicación en microservicios implica varios retos a los que hay que enfrentarse:
-	Latencia de red debido al acoplamiento que se crea en las comunicaciones entre microservicios.
-	Reducción de la disponibilidad debido a comunicaciones síncronas entre los microservicios, si un microservicio sufre una caída, todos los microservicios que dependen de él verán afectada su funcionalidad.
-	Mantener la consistencia de datos a través de los microservicios, cada microservicio dispondrá de una base datos propia de almacenamiento y no podrá acceder a la base de datos de otro microservicio.
-	La obtención de una vista consistente de los datos en un sistema en el que no existe una base de datos centralizada.

**Resistencia a fallos y disponibilidad**
----------------
Lidiar con fallos inesperados es uno de los problemas más difíciles de resolver, especialmente en un sistema distribuido.

Un microservicio necesita ser resistente a fallos y poder reiniciarse con frecuencia sin que suponga un problema para la totalidad del sistema. Si un microservicio falla o es reiniciado no se debe producir ninguna perdida de datos en el sistema y estos datos deben seguir siendo consistentes.

Un sistema cloud debe tolerar los fallos e intentar recuperarse automáticamente de ellos. Por ejemplo, en el caso de un fallo de red, las apps clientes o los servicios clientes deben de tener una estrategia de recuperación reenviando mensajes o reintentando las solicitudes.

En cuanto a la disponibilidad se deben de diseñar un sistema en el que los microservicios se encuentren lo más aislados posible e independientes entre si. Esto evitará que la funcionalidad de un microservicio no se vea afectada por un fallo en el microservico del que depende. 

Desplegar los microservicios en contenedores permite crear fácilmente replicas del microservicio, lo que evita problemas de sobrecarga.

Estas características se han tenido en cuenta a la hora de diseñar este sistema basado en una arquitectura de microservicios y se volverá a hablar de ellas a lo largo de esta memoria.
**Diseño de la API Gateway**
----------------
La API gateway es un servicio que hace de punto de entrada a la aplicación desde el mundo exterior. Su principal función es la gestión del tráfico de entrada a los microservicios a través del enrutado y filtrado de solicitudes, aunque puede realizar otras funciones como la autenticación. También puede realizar la función de traductor de protocolos, por ejemplo comunicarse con el exterior de la aplicación a través de REST API y con el interior a través de una combinación de APIs REST y gRPC. En el caso de la aplicación desarrollada en este trabajo la comunicación de la API Gateway con el exterior y el interior de la aplicación es a través de APIs REST.

En la Figura~\ref{fig:apiGateway} se muestra el diseño del enrutado que la API Gatway realiza a los microservicios.
![fomainDesign](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/api-gateway.png)
La API Gateway esta compuesta por un Service Discovery, un Load Balancer y un Circuit Breaker que complementan su funcionalidad.

**Consistencia de datos en arquitecturas de microservicios**
----------------
Cada microservicio del sistema tiene su propia base de datos. Los datos almacenados en la base de datos del microservicio son privados y solo pueden ser accedidos a través de las APIs del microservicio. Esto implica el reto de cómo implementar procesos de negocio ento-to-end mientras se mantiene la consistencia a través de multiples microservicios.

Tomando como ejemplo la aplicación desarrollada durante la realización de este trabajo, el microservicio Catalog contiene la información de todos los Productos. El microservicio Inventory gestiona los datos temporales sobre el inventario de productos en tiendas y almacenes. Cuando el precio o el nombre de un producto cambia en el microservicio Catalog, este producto también debe de ser actualizado en el microservicio Inventory.

En una hipotética versión monolítica de esta aplicación, una actualización de un producto del catálogo sería una transacción inmediata en la tabla ProductInventory.

Sin embargo, en un aplicación basada en microservicios, la tabla ProductCatalog y la tabla ProductInventory son propiedad de sus respectivos microservicios. Ningún microservicio debe acceder nunca a la base de datos propiedad de otro microservicio de forma directa a través de queries, como se muestra en la Figura siguiente
![fomainDesign](privateDatabases.png)
El micorservicio Catalog no debe actualizar la tabla InventoryProduct directamente. Para actualizar el microservice Inventory, el microservicio Catalog  utilizará un tipo de consistencia futura basada en una comunicación asíncrona entre microservicios, mediante la integración de eventos (comunicación basada en mensaje y eventos), tal y como se ha diseñado en la aplicación presentada en este trabajo.

En la mayoría de los escenarios en los que se utiliza una arquitectura de microservicios se demanda un sistema con una gran disponibilidad y escalabilidad, sacrificando a cambio una alta consistencia. Estos sistemas se deben desarrollar utilizando técnicas que permitan trabajar con una consistencia débil.

El reto de mantener la consistencia de datos entre los microservicios esta también relacionado con la cuestión de como propagar los cambios a través de múltiples microservicios cuando ciertos datos necesitan estar replicados en aquellos microservicios que los necesitan. Por ejemplo, cuando es necesario tener el precio o el nombre de un producto en el microservicio Catalog y en el microservicio Inventory.

La solución que se ha utilizado para resolver este problema es usar técnicas de consistencia futura o eventual implementando patrones como Event-Driven (comunicación asíncrona manejada por eventos) e implementando un sistema Publish/Subscribe. Este tema de la comunicación entre microservicios será abordado a continuación.  

**Diseño de la comunicación entre microservicios**
----------------

Uno de los grandes retos que supone una arquitectura de microservicios es la comunicación entre los microservicios. A la hora de diseñar se deben de analizar los diferentes estilos de comunicación según el nivel de acoplamiento que los microservicios deben de tener. Dependiendo del nivel de acoplamiento, cuando un fallo ocurre, el impacto en el sistema variará significativamente. 

Los sistemas basados en una arquitectura de microservicios, se encuentran distribuidos en múltiples servicios alojados en diferentes servidores. Estos servicios pueden fallar, produciendo fallos parciales o fallos mayores que afectarían de forma crítica a la totalidad del sistema.

Una de los enfoques más populares debido a su simplicidad es implementar la comunicación entre microservicios síncrona basada en APIs REST, como se muestra en la siguiente figura.
![deploy](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/syncCommunication.png)

Este enfoque puede ser problemático si creamos cadenas largas de peticiones HTTP síncronas entre los microservicios:
-	Bloqueos entre microservicios y elevadas latencias. Debido a la naturaleza síncrona de HTTP, la solicitud original no obtendrá una respuesta hasta que todas las solicitudes internas hallan finalizado. Esto tendría un impacto negativo sobre el rendimiento de la aplicación que empeoraría con el escalado de la aplicación.
-	Acoplamiento entre microservicios con HTTP. Los servicios del negocio de un microservicio no debe de estar acoplado a los servicios del negocio de otro microservicio. Idealmente un microservicio no debería de conocer la existencia de ningún otro microservicio.
-	Mantener la consistencia de datos a través de los microservicios, cada microservicio dispondrá de una base datos propia de almacenamiento y no podrá acceder a la base de datos de otro microservicio.
-	Fallos en cualquier otro microservicio. En una cadena de microservicios enlazados por peticiones HTTP, cuando cualquier microservico de la cadena falla, todos los microservicios de la cadena fallarán.
Se ha diseñado una comunicación entre microservicios de tal modo que los microservicios realicen sus funciones de la forma más autónoma e independiente posible, reduciendo lo máximo posible las comunicaciones entre microservicios. Para ellos se ha implementado un estilo de comunicación entre microservicios principalmente asíncrona como se muestra en la siguiente figura, siguiendo los patrones de diseño y utilizando los protocolos de comunicación que se comentarán a continuación.
![deploy](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/asyncCommunication.png)
