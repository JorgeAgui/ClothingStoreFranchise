# Sistema basado en arquitectura de microservicios. Implementación de una aplicación cloud políglota.

**Organización GitHub del proyecto**
----------------

Con el fin de aislar el desarrollo de cada microservicio se ha creado un repositorio por cada microservicio. Estos repositorios se han agrupado en una organización que se encuentra en el siguiente enlace.

- [ClothingStoreFranchise](https://github.com/ClothingStoreFranchise)

**Resumen del Proyecto**
----------------

El objetivo de este proyecto de software es realizar un estudio avanzado sobre las arquitecturas de microservicios. Con el fin de poner en práctica los conocimientos aprendidos, se ha realizado el diseño e implementación de una aplicación basada en este tipo de arquitectura siguiendo las buenas prácticas recomendadas.

El resultado es una aplicación resistente a fallos, que ofrece una alta disponibilidad y una alta escalabilidad.

El front end de esta aplicación esta implementado por una aplicación Angular y el back end por un conjunto de microservicios implementados en Spring Boot o en ASP.Net Core. 

La comunicación entre la aplicación cliente y los microservicios es a través de la API Gateway como punto de entrada y se efectúa mediante API REST.

La comunicación entre microservicios se realiza de forma asíncrona mediante un bus de eventos (RabbitMQ) y cuando es requerido de forma síncrona mediante api REST.

La aplicación ha sido desplegada en Google Kubernetes Engine.

En el diagrama de despliegue siguiente queda representado de forma global el sistema.

![deploy](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/deploy_kubernetes.png)

**Final University Degree Project Spanish Report**
----------------

In the following link you can see an university report with the complete detail of an initial software project design version:

[<img src="https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/Portada-TFG.PNG" width="50%">](https://drive.google.com/file/d/1n8LRlJwmtoOt1zs1OlBMOuQQwCfEsge5/view?usp=sharing)

**Demo**
----------------

En el siguiente video se muestra una demo de una versión inicial de la aplicaión y los detalles del despliegue en Google Kubernetes Engine(GKE):

[<img src="https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/portada_demo.jpg" width="50%">](https://youtu.be/MIGo7PZA-PA)

**Diseño guiado por el Dominio (DDD)**
----------------

Para realizar el diseño del dominio de la arquitectura de microservicios que se utilizará para la implementación de la aplicación, se ha aplicado DDD y definido un microservicio por cada subdomain. Una vez estudiada y aplicada esta técnica con el apoyo de la información  obtenida durante la fase de análisis, se ha desglosado el modelo de dominio en subdomains que definen a los siguientes microservicios:

-	Microservicio Authentication: se encargará de gestionar el almacenamiento y autenticación de los usuarios del sistema generando JWTs (JSON Web Tokens).  
-	Microservicio Customers: se encargará de gestionar los clientes registrados en el sistema y su carro de la compra.
-	Microservicio Catalog: se encargará de la gestión de los productos del catálogo, de sus categorías y ofertas.
-	Microservicio  Inventory: se encargará de la gestión del inventario de productos en tiendas y almacenes.
-	Microservicio Employees: se encargará de la gestión de los empleados registrado en el sistema.
-	Microservicio Sales: se encargará de la gestión de las ventas online y en tiendas físicas.
En la figura siguiente se muestra el modelo de dominio del sistema desglosado en subdominios tras aplicar DDD. Cada subdominio representa el modelo de cada Microservicio que formará el sistema.
![fomainDesign](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/micro-domains.png)

Se puede ver en el modelo de dominio en diseño en la figura anterior que hay clases que están replicadas en subdominios distintos, como por ejemplo, la clase Producto del Microservicio Inventory que depende de la clase Producto del Microservicio Catalog. Estas clases representan a un Producto en una parte de la organización diferente, el Catálogo y el Inventario. Cada una de ellas contiene la información necesaria para satisfacer las necesidades de la funcionalidad del Microservicio en el que se encuentra.

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

Desplegar los microservicios en contenedores permite crear fácilmente réplicas del microservicio, lo que evita problemas de sobrecarga. 

Estas características se han tenido en cuenta a la hora de diseñar este sistema basado en una arquitectura de microservicios.

**Diseño de la API Gateway**
----------------

La API Gateway proporciona a los clientes un único punto de entrada al sistema. Su principal función es la gestión del tráfico de entrada a los microservicios a través del enrutado y filtrado de solicitudes, aunque puede implementar otras funciones como la autenticación. También puede realizar la función de traductor de protocolos, por ejemplo, comunicarse con el exterior de la aplicación a través de REST API y con el interior a través de una combinación de APIs REST y gRPC. En el caso de la aplicación desarrollada en este trabajo la comunicación de la API Gateway con el exterior y el interior de la aplicación es a través de APIs REST.
En la Figura siguiente se muestra el diseño del enrutado que la API Gatway realiza a los microservicios.
![apiGateway](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/api-gateway.png)
La API Gateway esta compuesta por un Service Discovery, un Load Balancer y un Circuit Breaker que complementan su funcionalidad.

**Consistencia de datos en arquitecturas de microservicios**
----------------

Cada microservicio del sistema tiene su propia base de datos. Los datos almacenados en la base de datos del microservicio son privados y solo pueden ser accedidos a través de las APIs del microservicio. Esto supone un reto de diseño a la hora de implementar procesos de negocio ento-to-end mientras se mantiene la consistencia a través de múltiples microservicios.

Tomando como ejemplo la aplicación desarrollada, el microservicio Catalog contiene la información de todos los Productos. El microservicio Inventory gestiona los datos temporales sobre el inventario de productos en tiendas y almacenes. Cuando el precio o el nombre de un producto cambia en el microservicio Catalog, este producto también debe de ser actualizado en el microservicio Inventory.

En una hipotética versión monolítica de esta aplicación, una actualización de un producto del catálogo sería una transacción inmediata en la tabla ProductInventory.

Sin embargo, en una aplicación basada en microservicios, la tabla ProductCatalog y la tabla ProductInventory son propiedad de sus respectivos microservicios. Ningún microservicio debe acceder nunca a la base de datos propiedad de otro microservicio de forma directa a través de queries, como se muestra en la Figura siguiente
![privateDatabases](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/privateDatabases.png)

El micorservicio Catalog no debe actualizar la tabla InventoryProduct directamente. Para actualizar el microservice Inventory, el microservicio Catalog  utilizará un tipo de consistencia futura basada en una comunicación asíncrona entre microservicios, mediante la integración de eventos (comunicación basada en mensaje y eventos), tal y como se ha diseñado en esta aplicación.

En la mayoría de los escenarios en los que se utiliza una arquitectura de microservicios se demanda un sistema con una gran disponibilidad y escalabilidad, sacrificando a cambio una alta consistencia. Estos sistemas se deben desarrollar utilizando técnicas que permitan trabajar con una consistencia débil.

El reto de mantener la consistencia de datos entre los microservicios, esta directamente relacionado con la cuestión de como propagar los cambios a través de múltiples microservicios cuando ciertos datos necesitan estar replicados en aquellos microservicios que los necesitan. Por ejemplo, cuando es necesario tener el precio o el nombre de un producto en el microservicio Catalog y en el microservicio Inventory.

La solución que se ha utilizado para resolver este problema es usar técnicas de consistencia futura o eventual, implementando patrones como Event-Driven (comunicación asíncrona manejada por eventos) e implementando un sistema Publish/Subscribe. Este tema de la comunicación entre microservicios será abordado a continuación.

**Diseño de la comunicación entre microservicios**
----------------

Uno de los grandes retos que supone una arquitectura de microservicios es la comunicación entre los microservicios. A la hora de diseñar, se deben de analizar los diferentes estilos de comunicación según el nivel de acoplamiento que los microservicios deben de tener. Dependiendo del nivel de acoplamiento, cuando un fallo ocurre, el impacto en el sistema variará significativamente. 

Los sistemas basados en una arquitectura de microservicios, se encuentran distribuidos en múltiples servicios alojados en diferentes servidores. Estos servicios pueden fallar, produciendo fallos parciales o fallos mayores que afectarían de forma crítica a la totalidad del sistema.

Una de los enfoques más populares debido a su simplicidad es implementar la comunicación entre microservicios síncrona basada en APIs REST, como se muestra en la siguiente figura.
![deploy](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/syncCommunication.png)
Este enfoque puede ser problemático si creamos cadenas largas de peticiones HTTP síncronas entre los microservicios:
-	Bloqueos entre microservicios y elevadas latencias. Debido a la naturaleza síncrona de HTTP, la solicitud original no obtendrá una respuesta hasta que todas las solicitudes internas hallan finalizado. Esto tendría un impacto negativo sobre el rendimiento de la aplicación que empeoraría con el escalado de la aplicación.
-	Acoplamiento entre microservicios con HTTP. Los servicios del negocio de un microservicio no debe de estar acoplado a los servicios del negocio de otro microservicio. Idealmente un microservicio no debería de conocer la existencia de ningún otro microservicio.
-	Mantener la consistencia de datos a través de los microservicios, cada microservicio dispondrá de una base datos propia de almacenamiento y no podrá acceder a la base de datos de otro microservicio.
-	Fallos en cualquier otro microservicio. En una cadena de microservicios enlazados por peticiones HTTP, cuando cualquier microservico de la cadena falla, todos los microservicios de la cadena fallarán.

Se ha diseñado una comunicación entre microservicios, de tal modo que los microservicios realicen sus funciones de la forma más autónoma e independiente posible, reduciendo lo máximo posible las comunicaciones entre microservicios. Para ellos, se ha implementado un estilo de comunicación entre microservicios principalmente asíncrona como se muestra en la siguiente figura, siguiendo los patrones de diseño y utilizando los protocolos de comunicación que se comentarán a continuación.
![deploy](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/asyncCommunication.png)

**Protocolos de comunicación**
----------------

El diseño de la comunicación entre miscorservicios de la aplicación presentada en este trabajo esta orientada a reducir la cantidad de comunicaciones entre los microservicios lo máximo posible y a propagar los datos de forma asíncrona. Pero en algunos casos aislados puede darse la necesidad de una comunicación síncrona entre microservicios. En esta aplicación se han implementado dos tipo de protocolos:

-	HTTP (Hypertext Transfer Protocol): permite una comunicación mediante solicitud/respuesta síncrona. Se implementará como APIs REST y su principal utilización será en la comunicación entre el cliente y los microservios a través de la API Gateway. El cliente debe de recibir una respuesta del sistema de forma síncrona y este protocolo es ideal. También en la comunicación entre microservicios, puede darse el caso de que un microservicio necesite una respuesta síncrona de otro microservicio, este protocolo sería una opción válida.
-	AMQP (Advanced Message Queuing Protocol): permite una comunicación solicitud/respuesta asíncrona y síncrona, además de estar diseñado para utilizarse en un sistema publish/subcribe. Se implementará mediante un bus de eventos. Será el principal protocolo de comunicación entre microservicios, debido a su tipo de comunicación asíncrona y a que encaja perfectamente en un sistema publish/subscribe, lo que lo hace ideal para la propagación de datos entre microservicios.
Aunque implementar un bus de eventos respaldado por AMQP es más versátil al permitir un mayor número de métodos de comunicación además de la posibilidad de persistir los mensajes, implementar APIs REST respaldadas por HTTP es mucho más sencillo y requiere una curva de aprendizaje mucho menor que implementar un bus de eventos.

**Comunicación asíncrona basada en mensajes**
----------------
Como se mencionó en apartados anteriores, las entidades de los modelos como Product, Warehouse, Shop... pueden tener significado diferente en microservicios diferentes. Esto significa que ciertos datos de las entidades replicadas por los microservicios deben de ser actualizadas por el microservicio propietario de la información.
La solución que se implementará para propagar los cambios a través de múltiples microservicios será una consistencia de datos eventual y una comunicación manejada por eventos (event-driven) basada en mensajes asíncronos.
Al utilizar mensajería, los procesos se comunican intercambiando mensajes de forma asíncrona. El cliente envía una solicitud a un servicio enviando un mensaje, si el servicio necesita responder al cliente, envía un mensaje diferente de respuesta al cliente. El cliente asume que la respuesta no será inmediata o que no recibirá respuesta.
Un mensaje esta compuesto por una cabecera y un cuerpo. Los mensajes serán enviados mediante el protocolo AMQP. 
En una comunicación manejada por eventos (event-driven), un microservicio publica eventos en un bus de eventos cuando algo cambie en su dominio y varios microservicios se subscriben a esos eventos para ser notificados de forma asíncrona siempre que se realice una publicación de dichos eventos. Este sistema publish/subscribe será implementado usando un bus de eventos.

**Event Sourcing simplificado**
----------------

Cuando se publican eventos a través de un sistema distribuido de mensajería como un bus de eventos, existe el problema de actualizar de forma atómica la base de datos del microservicio y de publicar el evento. Se debe de evitar el caso en el que por algún motivo se produzca un fallo al persistir los datos en la base de datos del microservicio y estos datos si que se publiquen en el bus de eventos o viceversa. Esto dejaría el sistema en un estado inconsistente.

La solución que se llevará a cabo será implementar una simplificación del patrón Event Sourcing combinado con una tabla de base de datos transaccional. Se usarán estados en los eventos como "listo para publicar", esto eventos se almacenarán en una tabla llamada IntegrationEventLog y se actualizará su estado según vaya progresando en sus fases desde que se crea el evento hasta que se publica.
En la siguiente figura se muestra el diseño de la tabla IntegrationEventLog.

![integrationEventDB](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/integrationEventDB.png )

Cada microservicio tendrá su propia tabla IntegrationEventLog en su base de datos relacional. Esta tabla funciona como un resguardo para lograr la atomicidad, de modo que se persistan los eventos en las mismas transacciones que se persisten los datos de su dominio.

Si la publicación de un evento falla, los datos no serán inconsistentes, ya que el evento seguirá en la tabla IntegrationEventLog con el estado "listo para publicar". Este evento se reintentará publicar cuando se reinicie el microservicio o el bus de eventos.

Con este enfoque se almacenarán los eventos en la tabla IntegrationEventLog únicamente en los microservicios que vayan a publicar el evento (microservicios productores del evento).

**Diagramas de comunicación**
----------------
En este apartado se explicará de manera resumida y con ayuda de diagramas de se
-	Publish/Subscribe:
Patrón de mensajería asíncrono que se ha utilizado para propagar los cambios en los datos del dominio en los microservicios en los que se encuentren replicados.

El microservicio Publisher publica un evento en el message broker con una filosofía de envía y olvida. Los microservicios subscritos a ese evento (Subscribers) recibirán los datos del evento de forma asíncrona. El microservicio Publisher es el propietario de los datos que publica, estos datos no deben de ser modificados por ningún microservicio Subscriber. En los diagramas de secuencia siguientes se muestra cómo se han diseñado las comunicaciones para la aplicación usando este patrón.
![CreateProductEvent](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/CreateProductEvent.png )

![UpdateWarehouseEvent](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/UpdateWarehouseEvent.png )

![UpdateStockEvent](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/UpdateStockEvent.png )
-	Request/Response asíncrono:
Método de comunicación punto a punto. El microservicio cliente envía una solicitud que es recibida por el microservicio servidor de forma asíncrona, el microservicio servidor procesa la solicitud y envía una respuesta al cliente que también será recibida de forma asíncrona.
![UpdateStockEvent](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/ValidateOrderEvent.png )

**Diseño de la autenticación del sistema**
----------------
Las cuentas de usuario serán propias del sistema y la autenticación a través de los microservicios se realizará mediante JWT (JSON Web Token). 
Con el fin de tener una mayor flexibilidad y control en el proceso de autenticación se implementará un microservicio de autenticación propio. Este microservicio tendrá como función principal gestionar la autenticación del sistema generando tokens de acceso que propagarán la identidad y los privilegios del usuario identificado a través de los microservicios. 
Con el fin de asegurar la seguridad del sistema los tokens de acceso generados por el micorservicio de autenticación serán firmados y cifrados, esto se realizará siguiendo los siguientes estándares:
-	JSON Web Signature (JWS): estándar definido en RFC 7515. JWS es usado para firmar digitalmente un token de acceso, es una forma de asegurar la integridad de una información muy serializable con la certeza de que dicha información no ha sido modificada desde que el token fue firmado. Su información puede ser leída por un simple decodificador Base64. No incluye cifrado, pero esta diseñado para trabajar con cifrado. La firma del token se realizará con el algoritmo asimétrico RS256 usando una clave pública.
-	JSON Web Encryption (JWE): estándar definido en RFC 7516. JWE es usado para cifrar un token de acceso, este token será completamente opaco para el cliente que lo usa como medio de autenticación y autorización. El cifrado del token se realizará con el algoritmo HS256 usando una clave privada.
En la Figura siguiente podemos ver una representación visual del diseño de la autenticación del sistema.
![authentication](https://github.com/JorgeAgui/ClothingStoreFranchise/blob/spanish/figures/authentication.png )

Cuando un cliente inicia sesión, el microservicio authentication genera un token firmado y cifrado que se almacena temporalmente en la aplicación cliente. Cuando la aplicación cliente realice cualquier solicitud al back end, este token de acceso será enviado en la cabecera de la solicitud http. La API Gateway descifra y valida el token cifrado (JWE), si todo es correcto enruta la solicitud con el token firmado (JWS) al microservicio correspondiente donde también será validado.

