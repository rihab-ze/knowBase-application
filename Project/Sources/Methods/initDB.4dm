//%attributes = {}
// general var
var $item : Object
var $users : cs:C1710.UserSelection
var $tags : cs:C1710.TagSelection
var $categories : cs:C1710.CategorySelection
var $articles : cs:C1710.ArticleSelection
var $tagArticles : cs:C1710.ArticleTagSelection
var $notification : cs:C1710.Notification

var $image : Picture
var $request : 4D:C1709.HTTPRequest

// Generate Users
var $user : cs:C1710.UserEntity
var $fakeUsers : Collection
var $requestAvatar : 4D:C1709.HTTPRequest
var $avatar : Picture
var $currentUser : Object
var $success : Boolean

$currentUser:={email: "user@4d.com"; firstname: "user"; lastname: "user"; role: "Admin"}
If ($currentUser.email#Null:C1517)
	$user:=ds:C1482.User.query("email = :1"; $currentUser.email).first()
	If ($user=Null:C1517)
		$success:=ds:C1482.User.create($currentUser.email; $currentUser.firstname; $currentUser.lastname; $currentUser.role)
		If ($success)
			$user:=ds:C1482.User.query("email = :1"; $currentUser.email).first()
		End if 
	End if 
	
	Use (Session:C1714.storage)
		Session:C1714.storage.playload:=New shared object:C1526("ID"; $user.ID; "email"; $user.email; "role"; $user.role)
	End use 
	Session:C1714.setPrivileges($user.role)
End if 

$fakeUsers:=[]

$fakeUsers.push(\
New object:C1471("lastname"; "admin"; "firstname"; "admin"; "email"; "admin@4d.com"; "creationDate"; Current date:C33; "role"; "Admin"); \
New object:C1471("lastname"; "Laramée"; "firstname"; "Philip"; "email"; "philipe.laramee@4d.com"; "creationDate"; Current date:C33; "role"; "Learner"); \
New object:C1471("lastname"; "Devoe"; "firstname"; "Vail"; "email"; "Vail.Devoe@4d.com"; "creationDate"; Current date:C33; "role"; "Tutor"))
$fakeUsers.push(\
New object:C1471("lastname"; "Smith"; "firstname"; "John"; "email"; "john.smith@4d.com"; "creationDate"; Current date:C33; "role"; "Learner"); \
New object:C1471("lastname"; "Johnson"; "firstname"; "Emily"; "email"; "emily.johnson@4d.com"; "creationDate"; Current date:C33; "role"; "Tutor"); \
New object:C1471("lastname"; "Brown"; "firstname"; "Michael"; "email"; "michael.brown@4d.com"; "creationDate"; Current date:C33; "role"; "Learner"); \
New object:C1471("lastname"; "Davis"; "firstname"; "Olivia"; "email"; "olivia.davis@4d.com"; "creationDate"; Current date:C33; "role"; "Tutor"); \
New object:C1471("lastname"; "Wilson"; "firstname"; "Daniel"; "email"; "daniel.wilson@4d.com"; "creationDate"; Current date:C33; "role"; "Tutor"))
$fakeUsers.push(\
New object:C1471("lastname"; "Anderson"; "firstname"; "Sophia"; "email"; "sophia.anderson@4d.com"; "creationDate"; Current date:C33; "role"; "Tutor"); \
New object:C1471("lastname"; "Martinez"; "firstname"; "Liam"; "email"; "liam.martinez@4d.com"; "creationDate"; Current date:C33; "role"; "Learner"); \
New object:C1471("lastname"; "Garcia"; "firstname"; "Isabella"; "email"; "isabella.garcia@4d.com"; "creationDate"; Current date:C33; "role"; "Admin"); \
New object:C1471("lastname"; "Thomas"; "firstname"; "James"; "email"; "james.thomas@4d.com"; "creationDate"; Current date:C33; "role"; "Learner"); \
New object:C1471("lastname"; "Robinson"; "firstname"; "Ava"; "email"; "ava.robinson@4d.com"; "creationDate"; Current date:C33; "role"; "Tutor"))
$fakeUsers.push(\
New object:C1471("lastname"; "Lee"; "firstname"; "Ethan"; "email"; "ethan.lee@4d.com"; "creationDate"; Current date:C33; "role"; "Tutor"); \
New object:C1471("lastname"; "Walker"; "firstname"; "Mia"; "email"; "mia.walker@4d.com"; "creationDate"; Current date:C33; "role"; "Admin"); \
New object:C1471("lastname"; "Hall"; "firstname"; "Noah"; "email"; "noah.hall@4d.com"; "creationDate"; Current date:C33; "role"; "Admin"); \
New object:C1471("lastname"; "Allen"; "firstname"; "Emma"; "email"; "emma.allen@4d.com"; "creationDate"; Current date:C33; "role"; "Tutor"); \
New object:C1471("lastname"; "Baker"; "firstname"; "Lucas"; "email"; "lucas.baker@4d.com"; "creationDate"; Current date:C33; "role"; "Tutor"))
$fakeUsers.push(\
New object:C1471("lastname"; "Gonzalez"; "firstname"; "Sophie"; "email"; "sophie.gonzalez@4d.com"; "creationDate"; Current date:C33; "role"; "Learner"); \
New object:C1471("lastname"; "Clark"; "firstname"; "Alexander"; "email"; "alexander.clark@4d.com"; "creationDate"; Current date:C33; "role"; "Learner"); \
New object:C1471("lastname"; "Rodriguez"; "firstname"; "Chloe"; "email"; "chloe.rodriguez@4d.com"; "creationDate"; Current date:C33; "role"; "Tutor"); \
New object:C1471("lastname"; "Parker"; "firstname"; "William"; "email"; "william.parker@4d.com"; "creationDate"; Current date:C33; "role"; "Learner"); \
New object:C1471("lastname"; "Wright"; "firstname"; "Avery"; "email"; "avery.wright@4d.com"; "creationDate"; Current date:C33; "role"; "Learner"))
$fakeUsers.push(\
New object:C1471("lastname"; "Adams"; "firstname"; "Grace"; "email"; "grace.adams@4d.com"; "creationDate"; Current date:C33; "role"; "Tutor"); \
New object:C1471("lastname"; "Cook"; "firstname"; "Logan"; "email"; "logan.cook@4d.com"; "creationDate"; Current date:C33; "role"; "Admin"); \
New object:C1471("lastname"; "Bell"; "firstname"; "Harper"; "email"; "harper.bell@4d.com"; "creationDate"; Current date:C33; "role"; "Admin"); \
New object:C1471("lastname"; "Diaz"; "firstname"; "Elijah"; "email"; "elijah.diaz@4d.com"; "creationDate"; Current date:C33; "role"; "Tutor"); \
New object:C1471("lastname"; "Stewart"; "firstname"; "Scarlett"; "email"; "scarlett.stewart@4d.com"; "creationDate"; Current date:C33; "role"; "Tutor"))
//$fakeUsers.push(\
New object("lastname"; "Rivera"0"firstname"0"Aiden"0"email"0"aiden.rivera@4d.com"0"creationDate".currentDate0"role"; "Tutor"); \
New object("lastname"; "Price"0"firstname"0"Hannah"0"email"0"hannah.price@4d.com"0"creationDate".currentDate0"role"; "Admin"); \
New object("lastname"; "Bailey"0"firstname"0"Nathan"0"email"0"nathan.bailey@4d.com"0"creationDate".currentDate0"role"; "Admin"); \
New object("lastname"; "Cooper"0"firstname"0"Lily"0"email"0"lily.cooper@4d.com"0"creationDate".currentDate0"role"; "Admin"); \
New object("lastname"; "Flores"0"firstname"0"Evelyn"0"email"0"evelyn.flores@4d.com"0"creationDate".currentDate0"role"; "Admin")\)
//$fakeUsers.push(\
New object("lastname"; "Chen"0"firstname"0"Liam"0"email"0"liam.chen@4d.com"0"creationDate".currentDate0"role"; "Learner"); \
New object("lastname"; "Graham"0"firstname"0"Zoe"0"email"0"zoe.graham@4d.com"0"creationDate".currentDate0"role"; "Learner"); \
New object("lastname"; "Perry"0"firstname"0"William"0"email"0"william.perry@4d.com"0"creationDate".currentDate0"role"; "Tutor"); \
New object("lastname"; "Nguyen"0"firstname"0"Aria"0"email"0"aria.nguyen@4d.com"0"creationDate".currentDate0"role"; "Learner"); \
New object("lastname"; "Reed"0"firstname"0"Gabriel"0"email"0"gabriel.reed@4d.com"0"creationDate".currentDate0"role"; "Tutor")\)
//$fakeUsers.push(\
New object("lastname"; "Carter"0"firstname"0"Ella"0"email"0"ella.carter@4d.com"0"creationDate".currentDate0"role"; "Admin"); \
New object("lastname"; "Murphy"0"firstname"0"Jack"0"email"0"jack.murphy@4d.com"0"creationDate".currentDate0"role"; "Tutor"); \
New object("lastname"; "Morris"0"firstname"0"Layla"0"email"0"layla.morris@4d.com"0"creationDate".currentDate0"role"; "Admin"); \
New object("lastname"; "Brooks"0"firstname"0"Henry"0"email"0"henry.brooks@4d.com"0"creationDate".currentDate0"role"; "Admin"); \
New object("lastname"; "Barnes"0"firstname"0"Grace"0"email"0"grace.barnes@4d.com"0"creationDate".currentDate0"role"; "Admin")\)
//$fakeUsers.push(\
New object("lastname"; "Powell"0"firstname"0"Lucas"0"email"0"lucas.powell@4d.com"0"creationDate".currentDate0"role"; "Admin"); \
New object("lastname"; "Russell"0"firstname"0"Samantha"0"email"0"samantha.russell@4d.com"0"creationDate".currentDate0"role"; "Tutor"); \
New object("lastname"; "Bryant"0"firstname"0"Mason"0"email"0"mason.bryant@4d.com"0"creationDate".currentDate0"role"; "Admin"); \
New object("lastname"; "Foster"0"firstname"0"Madison"0"email"0"madison.foster@4d.com"0"creationDate".currentDate0"role"; "Admin"); \
New object("lastname"; "Jenkins"0"firstname"0"Benjamin"0"email"0"benjamin.jenkins@4d.com"0"creationDate".currentDate0"role"; "Tutor")\)

For each ($item; $fakeUsers)
	$user:=ds:C1482.User.new()
	$user.firstname:=$item.firstname
	$user.lastname:=$item.lastname
	$user.email:=$item.email
	$user.password:=Generate password hash:C1533("123456")
	$user.creationDate:=$item.creationDate
	$user.role:=$item.role
	$user.active:=True:C214
	$requestAvatar:=4D:C1709.HTTPRequest.new("https://picsum.photos/200").wait()
	If ($requestAvatar.response#Null:C1517)
		BLOB TO PICTURE:C682($requestAvatar.response.body; $avatar)
		$user.avatar:=$avatar
	End if 
	$user.save()
End for each 

$users:=ds:C1482.User.all()

// Generate Category
var $category : Collection
var $cat : cs:C1710.CategoryEntity

$category:=[]
$category.push(\
New object:C1471("label"; "Software Development"); \
New object:C1471("label"; "Networking and Security"); \
New object:C1471("label"; "Cloud Computing"); \
New object:C1471("label"; "Testing"); \
New object:C1471("label"; "DevOps"); \
New object:C1471("label"; "Cloud Computing"); \
New object:C1471("label"; "Networking and Security"); \
New object:C1471("label"; "DevOps"); \
New object:C1471("label"; "Testing"); \
New object:C1471("label"; "Machine Learning"); \
New object:C1471("label"; "Data Science"); \
New object:C1471("label"; "Artificial Intelligence"); \
New object:C1471("label"; "Big Data"); \
New object:C1471("label"; "Cloud Computing"); \
New object:C1471("label"; "Big Data"); \
New object:C1471("label"; "Data Analytics"); \
New object:C1471("label"; "Business Intelligence"); \
New object:C1471("label"; "Data Visualization"); \
New object:C1471("label"; "Blockchain"); \
New object:C1471("label"; "Cryptocurrency"); \
New object:C1471("label"; "Web3"); \
New object:C1471("label"; "Decentralization"); \
New object:C1471("label"; "Fintech"); \
New object:C1471("label"; "Cybersecurity"); \
New object:C1471("label"; "Information Security"); \
New object:C1471("label"; "Network Security"); \
New object:C1471("label"; "Application Security"); \
New object:C1471("label"; "End-User Security"); \
New object:C1471("label"; "Web Development"); \
New object:C1471("label"; "Front-End Development"); \
New object:C1471("label"; "Back-End Development"); \
New object:C1471("label"; "Full-Stack Development"); \
New object:C1471("label"; "Mobile Development"); \
New object:C1471("label"; "UI/UX Design"); \
New object:C1471("label"; "Graphic Design"); \
New object:C1471("label"; "Product Design"); \
New object:C1471("label"; "Service Design"); \
New object:C1471("label"; "UX Research"); \
New object:C1471("label"; "Product Management"); \
New object:C1471("label"; "Project Management"); \
New object:C1471("label"; "Agile Development"); \
New object:C1471("label"; "Scrum"); \
New object:C1471("label"; "Kanban"); \
New object:C1471("label"; "Marketing"); \
New object:C1471("label"; "Sales"); \
New object:C1471("label"; "Growth Hacking"); \
New object:C1471("label"; "Object-Oriented Programming"); \
New object:C1471("label"; "Functional Programming"); \
New object:C1471("label"; "Procedural Programming"); \
New object:C1471("label"; "Imperative Programming"); \
New object:C1471("label"; "Declarative Programming"); \
New object:C1471("label"; "Event-Driven Programming"); \
New object:C1471("label"; "Logic Programming"); \
New object:C1471("label"; "Aspect-Oriented Programming"); \
New object:C1471("label"; "Concurrent Programming"); \
New object:C1471("label"; "Parallel Programming"); \
New object:C1471("label"; "Data-Driven Programming"); \
New object:C1471("label"; "Component-Based Programming"); \
New object:C1471("label"; "Service-Oriented Programming"); \
New object:C1471("label"; "Event-Driven Architecture"); \
New object:C1471("label"; "Microservices Architecture"))

For each ($item; $category)
	$cat:=ds:C1482.Category.new()
	$cat.label:=$item.label
	$cat.save()
End for each 

$categories:=ds:C1482.Category.all()

// generate Tag
var $fakeTags : Collection
var $tag : cs:C1710.TagEntity

$fakeTags:=[]
$fakeTags.push(\
New object:C1471("label"; "CodeRefactoring"); \
New object:C1471("label"; "SoftwareDevelopment"); \
New object:C1471("label"; "Maintenance"); \
New object:C1471("label"; "Performance"); \
New object:C1471("label"; "Algorithms"); \
New object:C1471("label"; "AgileDevelopment"); \
New object:C1471("label"; "DesignPatterns"); \
New object:C1471("label"; "Debugging"); \
New object:C1471("label"; "Troubleshooting"); \
New object:C1471("label"; "UnitTesting"); \
New object:C1471("label"; "Containerization"); \
New object:C1471("label"; "Docker"); \
New object:C1471("label"; "iOSDevelopment"); \
New object:C1471("label"; "AndroidDevelopment"); \
New object:C1471("label"; "CrossPlatformDevelopment"); \
New object:C1471("label"; "MobileAppDesign"); \
New object:C1471("label"; "MobileAppTesting"); \
New object:C1471("label"; "AppSecurity"); \
New object:C1471("label"; "AppPerformance"); \
New object:C1471("label"; "PushNotifications"); \
New object:C1471("label"; "InAppPurchases"); \
New object:C1471("label"; "MobileAppAnalytics"); \
New object:C1471("label"; "AugmentedReality"); \
New object:C1471("label"; "AppPublishing"))

For each ($item; $fakeTags)
	$tag:=ds:C1482.Tag.new()
	$tag.label:=$item.label
	$tag.save()
End for each 
$tags:=ds:C1482.Tag.all()

// Generate Articles

var $fakeArticles : Collection
var $article : cs:C1710.ArticleEntity
var $randomNums : Integer
$fakeArticles:=[]

$fakeArticles.push(\
New object:C1471("title"; "The Art of Code Refactoring"; \
"content"; "In this article; we explore the importance of code refactoring in software development. Code refactoring is the process of restructuring existing code to improve its readability; maintainability; and performance. We discuss various refactoring techniq"+"ues; best practices; and tools that developers can use to efficiently refactor their code and create a more robust software system."; \
"creationDate"; Current date:C33(); \
"creationTime"; Time:C179(2000); \
"public"; False:C215; \
"status"; False:C215)\
)

$fakeArticles.push(\
New object:C1471("title"; "Continuous Integration and Deployment with Jenkins"; \
"content"; "Continuous integration and deployment are essential practices in modern software development. This article focuses on Jenkins; a widely used automation server; and how it enables seamless integration; testing; and deployment of code changes. We walk t"+"hrough the setup of Jenkins pipelines; integration with version control systems; and automating the deployment process."; \
"creationDate"; Current date:C33(); \
"creationTime"; Time:C179(1000); \
"public"; False:C215; \
"status"; True:C214)\
)

$fakeArticles.push(\
New object:C1471("title"; "Agile Software Development: Scrum in Action"; \
"content"; "Agile software development methodologies; like Scrum; have gained immense popularity in recent years. In this article; we delve into the principles of Scrum and its practical implementation in software projects. We cover the roles of Scrum Master; Pro"+"duct Owner; and Development Team; as well as the Scrum events and artifacts that facilitate effective project management and delivery."; \
"creationDate"; Current date:C33(); \
"creationTime"; Time:C179(4000); \
"public"; False:C215; \
"status"; False:C215)\
)

$fakeArticles.push(\
New object:C1471("title"; "Web application security is a critical aspect of software engineering."; \
"content"; "In this article; we highlight the best practices for securing web applications against common vulnerabilities such as SQL injection; cross-site scripting (XSS); and cross-site request forgery (CSRF). We also discuss the importance of input validation;"+" "+" authentication; and authorization in building secure web applications."; \
"creationDate"; Current date:C33(); \
"creationTime"; Time:C179(3000); \
"public"; True:C214; \
"status"; True:C214)\
)

$fakeArticles.push(\
New object:C1471("title"; "Getting Started with React: Building Dynamic User Interfaces."; \
"content"; "React has become one of the most popular JavaScript libraries for building user interfaces. In this article; we provide a beginner-friendly guide to React; explaining its component-based architecture and how to create dynamic and interactive user inte"+"rfaces using React's state and props. We also introduce key concepts like JSX; virtual DOM; and React hooks."; \
"creationDate"; Current date:C33(); \
"creationTime"; Time:C179(5000); \
"public"; False:C215; \
"status"; False:C215)\
)

$fakeArticles.push(\
New object:C1471("title"; "Exploring Microservices Architecture for Scalable Applications"; \
"content"; "Microservices architecture has revolutionized the way we design and develop scalable applications. In this article; we discuss the concepts behind microservices; their benefits; and the challenges they pose. We explore how to break down monolithic app"+"lications into microservices; manage communication between them; and deploy them using containerization technologies like Docker and Kubernetes."; \
"creationDate"; Current date:C33(); \
"creationTime"; Time:C179(3200); \
"public"; True:C214; \
"status"; True:C214)\
)

$fakeArticles.push(\
New object:C1471("title"; "Understanding Design Patterns: Building Reusable Software Components"; \
"content"; "Design patterns are crucial for building maintainable and reusable software components. In this article; we explore common design patterns like Singleton; Factory Method; Observer; and Strategy; explaining their purposes and use cases. Understanding t"+"hese patterns empowers developers to architect scalable and flexible software systems."; \
"creationDate"; Current date:C33(); \
"creationTime"; Time:C179(5000); \
"public"; True:C214; \
"status"; True:C214)\
)

$fakeArticles.push(\
New object:C1471("title"; "Debugging Techniques for Efficient Software Development"; \
"content"; "Debugging is an essential skill for software engineers to identify and fix defects in their code. In this article; we present various debugging techniques and tools that can help streamline the debugging process. We cover techniques like logging; unit"+" testing; and using debugging tools like debuggers and profilers to troubleshoot issues effectively."; \
"creationDate"; Current date:C33(); \
"creationTime"; Time:C179(8000); \
"public"; False:C215; \
"status"; False:C215)\
)

$fakeArticles.push(\
New object:C1471("title"; "Test-Driven Development (TDD): Building Quality Software from the Start"; \
"content"; "Test-Driven Development (TDD) has gained popularity as a software development approach that emphasizes writing tests before writing the actual code. In this article; we delve into the principles of TDD; its benefits in ensuring code quality and mainta"+"inability; and best practices for implementing TDD in your development workflow."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "16:00:00"; \
"public"; False:C215; \
"status"; Null:C1517)\
)

$fakeArticles.push(\
New object:C1471("title"; "The Rise of DevOps: Bridging the Gap between Development and Operations"; \
"content"; "DevOps has revolutionized the software development and deployment process by bringing developers and operations teams closer together. This article explores the principles of DevOps; its impact on software delivery; and how it fosters collaboration; a"+"utomation; and continuous integration/continuous deployment (CI/CD) pipelines."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "16:30:00"; \
"public"; False:C215; \
"status"; True:C214)\
)

$fakeArticles.push(\
New object:C1471("title"; "Microservices Architecture: Building Scalable and Agile Systems"; \
"content"; "Microservices architecture has become a preferred approach for building complex and scalable software systems. This article examines the key concepts behind microservices; the benefits of decoupling services; and the challenges and best practices in a"+"dopting this architecture."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "17:00:00"; \
"public"; False:C215; \
"status"; Null:C1517)\
)

$fakeArticles.push(\
New object:C1471("title"; "The Role of Artificial Intelligence in Software Engineering"; \
"content"; "Artificial Intelligence (AI) is transforming the software engineering landscape; from code generation to automated testing and debugging. In this article; we explore how AI is reshaping the way developers write code; optimize performance; and enhance "+"user experiences."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "17:30:00"; \
"public"; False:C215; \
"status"; True:C214)\
)

$fakeArticles.push(\
New object:C1471("title"; "Security in Software Development: Best Practices for Fortifying Your Applications"; \
"content"; "Security is paramount in software development; given the increasing integer of cyber threats. This article covers essential security best practices; such as input validation; authentication; and secure coding; to protect your applications from vulnera"+"b"+"ilities and attacks."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "18:00:00"; \
"public"; False:C215; \
"status"; True:C214)\
)

$fakeArticles.push(\
New object:C1471("title"; "Continuous Integration and Continuous Deployment (CI/CD): Streamlining Software Delivery"; \
"content"; "CI/CD practices enable developers to continuously integrate code changes and deploy updates to production efficiently. This article discusses the benefits of CI/CD; popular tools; and how it accelerates the development lifecycle while ensuring code qu"+"ality and stability."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "18:30:00"; \
"public"; False:C215; \
"status"; Null:C1517)\
)

$fakeArticles.push(\
New object:C1471("title"; "The Power of Drag and Drop: Simplifying User Interactions in Software"; \
"content"; "Drag and drop functionality has transformed the way users interact with software applications. This article explores the benefits of drag and drop interfaces; their impact on user experience; and how developers can implement this intuitive feature in "+"their applications to enhance usability."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "19:00:00"; \
"public"; True:C214; \
"status"; True:C214)\
)

$fakeArticles.push(\
New object:C1471("title"; "Efficiency and Productivity: How Drag and Drop Editors Revolutionize Web Design"; \
"content"; "Web designers can now streamline their workflows and boost productivity with the help of drag and drop editors. This article explores the advantages of using drag and drop tools in web design; their impact on design iterations; and how designers can c"+"reate stunning websites without extensive coding knowledge."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "20:00:00"; \
"public"; False:C215; \
"status"; Null:C1517)\
)

$fakeArticles.push(\
New object:C1471("title"; "Creating Customizable Workflows with Drag and Drop Software Builders"; \
"content"; "Drag and drop software builders have made it easier for non-technical users to create customizable workflows and applications. In this article; we examine the capabilities of drag and drop builders; their role in empowering users; and some popular pla"+"tforms that enable users to build powerful applications without coding."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "19:30:00"; \
"public"; False:C215; \
"status"; True:C214)\
)

$fakeArticles.push(\
New object:C1471("title"; "The Evolution of Software Development Methodologies"; \
"content"; "In this article; we explore the history and evolution of software development methodologies; from the traditional Waterfall approach to Agile; Scrum; and Kanban. We discuss the advantages and disadvantages of each methodology and how they have shaped "+"the way software is built and delivered today."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "15:30:00"; \
"public"; False:C215; \
"status"; True:C214)\
)

$fakeArticles.push(\
New object:C1471("title"; "Introduction to Blockchain Technology: Building Decentralized Applications"; \
"content"; "Blockchain technology is disrupting various industries with its decentralized and transparent nature. In this article; we introduce the fundamentals of blockchain; exploring concepts like distributed ledgers; smart contracts; and consensus mechanisms."+" We also discuss how to develop decentralized applications (DApps) using popular blockchain platforms like Ethereum."; \
"creationDate"; Current date:C33(); \
"creationTime"; Time:C179(3000); \
"public"; True:C214; \
"status"; True:C214)\
)

$fakeArticles.push(\
New object:C1471("title"; "The Power of Cloud Computing in Modern Business"; \
"content"; "Cloud computing has revolutionized the way businesses operate. In this article; we delve into the various benefits of cloud computing; such as cost savings; scalability; and increased efficiency. We also examine real-world case studies of businesses l"+"everaging cloud technology to gain a competitive edge in their industries."; \
"creationDate"; "2023-07-24"; \
"creationTime"; "10:15:00"; \
"status"; False:C215)\
)

$fakeArticles.push(\
New object:C1471("title"; "The Rise of Artificial Intelligence in Healthcare"; \
"content"; "Artificial Intelligence (AI) is transforming the healthcare industry. From diagnosis and treatment to drug discovery and personalized medicine; AI is making significant strides. In this article; we explore the applications of AI in healthcare and its "+"potential to revolutionize patient care; improve outcomes; and reduce costs."; \
"creationDate"; "2023-07-24"; \
"creationTime"; "14:00:00"; \
"public"; False:C215; \
"status"; True:C214)\
)

$fakeArticles.push(\
New object:C1471("title"; "The Future of Blockchain Technology in Finance"; \
"content"; "Blockchain technology is disrupting the financial sector in unprecedented ways. This article dives into how blockchain enables secure and transparent transactions; eliminates intermediaries; and enhances financial inclusion. We also discuss potential "+"challenges and regulatory considerations as blockchain continues to shape the future of finance."; \
"creationDate"; "2023-07-25"; \
"creationTime"; "09:45:00"; \
"public"; False:C215; \
"status"; Null:C1517)\
)

$fakeArticles.push(\
New object:C1471("title"; "UX Design: Creating Exceptional User Experiences"; \
"content"; "User Experience (UX) design is a critical aspect of product development. In this article; we explore the principles of effective UX design; usability testing; and the impact of UX on customer satisfaction and retention. We also highlight the role of U"+"X in driving business success and share insights from industry experts on best practices."; \
"creationDate"; "2023-07-25"; \
"creationTime"; "13:20:00"; \
"public"; False:C215; \
"status"; True:C214)\
)

$fakeArticles.push(\
New object:C1471("title"; "The Cybersecurity Landscape: Challenges and Solutions"; \
"content"; "With the increasing frequency and sophistication of cyber-attacks; cybersecurity has become paramount for organizations. This article examines the current cybersecurity landscape; major threats; and common vulnerabilities. We delve into proactive meas"+"ures like ethical hacking; AI-powered security tools; and employee training to defend against cyber threats."; \
"creationDate"; "2023-07-26"; \
"creationTime"; "11:10:00"; \
"public"; False:C215; \
"status"; True:C214)\
)

var $usersFilter : cs:C1710.UserSelection
$usersFilter:=ds:C1482.User.query("role = :1 || role = :2"; "Admin"; "Tutor")

For each ($item; $fakeArticles)
	
	$article:=ds:C1482.Article.new()
	$article.title:=$item.title
	$article.content:=$item.content
	$article.creationDate:=$item.creationDate
	$article.creationTime:=$item.creationTime
	$article.published:=$item.status
	$article.public:=$item.public
	$randomNums:=(Random:C100%$usersFilter.length)
	$article.user:=$usersFilter[$randomNums]
	$randomNums:=(Random:C100%$categories.length)
	$article.category:=$categories[$randomNums]
	
	$request:=4D:C1709.HTTPRequest.new("https://picsum.photos/300/600").wait()
	If ($request.response#Null:C1517)
		BLOB TO PICTURE:C682($request.response.body; $image)
		$article.picture:=$image
	End if 
	
	$article.save()
End for each 

$articles:=ds:C1482.Article.all()

//Generate ArticleTag
var $tagArticle : cs:C1710.ArticleTagEntity
var $randomIndex : Integer
var $i; $j : Integer
For ($i; 0; $articles.length-1)
	$j:=(Random:C100%3)+1
	While ((1<=$j) && ($j<=3))
		$tagArticle:=ds:C1482.ArticleTag.new()
		$tagArticle.article:=$articles[$i]
		$randomIndex:=(Random:C100%$tags.length)
		$tagArticle.tag:=$tags[$randomIndex]
		$tagArticle.save()
		$j:=$j+1
	End while 
End for 

$tagArticles:=ds:C1482.ArticleTag.all()

// Generate Likes
var $like : cs:C1710.LikeEntity
var $randomNumber : Integer

$randomNumber:=(Random:C100%10)
$j:=0
While (j<$randomNumber)
	For ($i; 0; $users.length-1)
		$like:=ds:C1482.Like.new()
		$like.likeDate:=Current date:C33
		$like.likeTime:=Current time:C178
		$like.likedBy:=$users[$i]
		$randomIndex:=(Random:C100%$articles.length)
		$like.article:=$articles[$randomIndex]
		$like.save()
		$notification:=ds:C1482.Notification.generateNotifs($articles[$randomIndex].user; $users[$i]; $articles[$randomIndex]; "like")
	End for 
	$j:=$j+1
End while 

//Generate Comment
var $fakeComments : Collection
var $randomIndexArticle; randomIndexUser : Integer
var $comment : cs:C1710.CommentEntity

$fakeComments:=[]
$fakeComments.push(\
New object:C1471("content"; "Great article! I love how it delves into the topic without overwhelming the reader with technical jargon. Looking forward to more content like this!"; "creationDate"; Current date:C33(); "creationTime"; "00:02:12"); \
New object:C1471("content"; "Your articles are like a treasure trove of knowledge. I find myself coming back for more every time!"; "creationDate"; Current date:C33(); "creationTime"; "19:00:05"); \
New object:C1471("content"; "Your writing is so engaging that I lose track of time while reading your articles. Keep up the fantastic work!"; "creationDate"; Current date:C33(); "creationTime"; "21:20:15"); \
New object:C1471("content"; "I'm a teacher; and your articles have become a valuable resource in my classroom. My students love them too!"; "creationDate"; Current date:C33(); "creationTime"; "23:10:30"); \
New object:C1471("content"; "You have a knack for explaining complex concepts with real-life examples. It makes learning a breeze!"; "creationDate"; Current date:C33(); "creationTime"; "01:45:00"); \
New object:C1471("content"; "I'm amazed by the depth of knowledge you share in your articles. You're a true expert in your field!"; "creationDate"; Current date:C33(); "creationTime"; "03:25:12"); \
New object:C1471("content"; "Your passion for education and your readers' success is evident in every word you write. Truly inspiring!"; "creationDate"; Current date:C33(); "creationTime"; "05:12:38"); \
New object:C1471("content"; "I often struggle with technical topics; but your articles make them accessible and enjoyable. Thank you!"; "creationDate"; Current date:C33(); "creationTime"; "07:08:55"); \
New object:C1471("content"; "Hmm; I feel like the article could use more examples to support the main points. Nevertheless; it's well-written and informative"; "creationDate"; Current date:C33(); "creationTime"; "00:02:12"); \
New object:C1471("content"; "Your articles have become my go-to resource whenever I need to understand a new subject. Invaluable!"; "creationDate"; Current date:C33(); "creationTime"; "09:35:20"); \
New object:C1471("content"; "I've shared your articles with my colleagues; and they're all amazed by the clarity and depth of your explanations."; "creationDate"; Current date:C33(); "creationTime"; "11:40:10"); \
New object:C1471("content"; "Your articles are not only informative but also enjoyable to read. You make learning a pleasure!"; "creationDate"; Current date:C33(); "creationTime"; "13:55:55"); \
New object:C1471("content"; "Your articles have ignited a passion for learning in me. I can't thank you enough for the inspiration!"; "creationDate"; Current date:C33(); "creationTime"; "15:20:18"); \
New object:C1471("content"; "Your enthusiasm for sharing knowledge is contagious. I feel energized to pursue my educational goals!"; "creationDate"; Current date:C33(); "creationTime"; "05:25:15"); \
New object:C1471("content"; "The structure of the article is on point! Clear introduction; logical flow; and a solid conclusion. Well done"; "creationDate"; Current date:C33(); "creationTime"; "00:02:12"); \
New object:C1471("content"; "I always look forward to your articles because I know they will be informative; engaging; and well-written."; "creationDate"; Current date:C33(); "creationTime"; "17:15:30"); \
New object:C1471("content"; "Your ability to simplify complex ideas is remarkable. You make learning challenging topics feel achievable."; "creationDate"; Current date:C33(); "creationTime"; "19:10:45"); \
New object:C1471("content"; "As a fellow educator; I admire your dedication to spreading knowledge. Your articles are a valuable resource!"; "creationDate"; Current date:C33(); "creationTime"; "21:30:05"); \
New object:C1471("content"; "Your articles are like a beacon of light in the vast sea of information. I'm grateful for your guidance."; "creationDate"; Current date:C33(); "creationTime"; "23:45:22"); \
New object:C1471("content"; "Your articles have become a staple in my learning journey. They've transformed me from a novice to a confident learner!"; "creationDate"; Current date:C33(); "creationTime"; "01:18:08"); \
New object:C1471("content"; "I've learned more from your articles than from any expensive course. You're making education accessible to all!"; "creationDate"; Current date:C33(); "creationTime"; "03:50:40"); \
New object:C1471("content"; "As someone new to article writing; this was a helpful read. It provided practical tips that I can implement in my own work. Thanks!"; "creationDate"; Current date:C33(); "creationTime"; "00:02:12"); \
New object:C1471("content"; "Your articles are like a breath of fresh air. They make complex topics feel fascinating and approachable."; "creationDate"; Current date:C33(); "creationTime"; "07:30:30"); \
New object:C1471("content"; "I've recommended your articles to my friends; and they all share my excitement for the wealth of insights you offer."; "creationDate"; Current date:C33(); "creationTime"; "09:15:55"); \
New object:C1471("content"; "Your articles have changed the way I approach learning. I now see it as a journey of self-discovery."; "creationDate"; Current date:C33(); "creationTime"; "19:55:05"); \
New object:C1471("content"; "I'm amazed at how you manage to make seemingly boring topics so engaging and relevant. Bravo!"; "creationDate"; Current date:C33(); "creationTime"; "01:08:50"); \
New object:C1471("content"; "I appreciate the effort to cite sources; but some of the links seem outdated. It would be great if the author could update them."; "creationDate"; Current date:C33(); "creationTime"; "00:02:12"); \
New object:C1471("content"; "Your articles are like a knowledge buffet - I can't get enough! Each one leaves me hungry for more learning."; "creationDate"; Current date:C33(); "creationTime"; "11:00:05"); \
New object:C1471("content"; "I've never been so excited about learning before! Your articles make complex topics feel like an adventure."; "creationDate"; Current date:C33(); "creationTime"; "13:20:18"); \
New object:C1471("content"; "Your dedication to sharing knowledge is admirable. You're empowering learners all around the world."; "creationDate"; Current date:C33(); "creationTime"; "15:10:30"); \
New object:C1471("content"; "I've found answers to questions I didn't even know I had in your articles. Truly eye-opening and enriching!"; "creationDate"; Current date:C33(); "creationTime"; "17:25:22"); \
New object:C1471("content"; "Your articles are like a mentor guiding me on my learning journey. I couldn't ask for a better teacher!"; "creationDate"; Current date:C33(); "creationTime"; "19:45:40"); \
New object:C1471("content"; "I've been recommending your articles to my colleagues at work; and they're equally impressed!"; "creationDate"; Current date:C33(); "creationTime"; "21:35:55"); \
New object:C1471("content"; "Nice article! But could you provide more in-depth explanations of certain concepts? I'm hungry for more knowledge!"; "creationDate"; Current date:C33(); "creationTime"; "00:02:12"); \
New object:C1471("content"; "Your passion for education is evident in every sentence. Your articles motivate me to be a lifelong learner."; "creationDate"; Current date:C33(); "creationTime"; "23:20:10"); \
New object:C1471("content"; "Your articles strike the perfect balance between simplicity and depth. They cater to learners of all levels."; "creationDate"; Current date:C33(); "creationTime"; "01:15:38"); \
New object:C1471("content"; "I was struggling with self-study; but your articles have given me the confidence to learn independently."; "creationDate"; Current date:C33(); "creationTime"; "03:40:05"); \
New object:C1471("content"; "Your articles are my go-to resource whenever I encounter a new subject. They're like my virtual tutor!"; "creationDate"; Current date:C33(); "creationTime"; "05:55:20"); \
New object:C1471("content"; "Great work! I love how you explained the complex topic in a simple and easy-to-understand way."; "creationDate"; Current date:C33(); "creationTime"; "01:30:45"); \
New object:C1471("content"; "This article is so insightful. I've learned a lot from reading it. Thank you for sharing your knowledge!"; "creationDate"; Current date:C33(); "creationTime"; "09:15:20"); \
New object:C1471("content"; "I'm a fan of your work. The depth of analysis you provide is unparalleled. Keep it up!"; "creationDate"; Current date:C33(); "creationTime"; "12:10:10"); \
New object:C1471("content"; "Your articles are fantastic! They provide a clear and comprehensive overview of the topic."; "creationDate"; Current date:C33(); "creationTime"; "14:25:30"); \
New object:C1471("content"; "I appreciate the effort you put into writing these articles. They are always informative and well-researched."; "creationDate"; Current date:C33(); "creationTime"; "16:00:50"); \
New object:C1471("content"; "Thank you for the insightful article. Your writing style makes complex subjects easy to grasp."; "creationDate"; Current date:C33(); "creationTime"; "18:35:12"); \
New object:C1471("content"; "I found this article very helpful. It clarified many doubts I had about the topic."; "creationDate"; Current date:C33(); "creationTime"; "21:50:30"))

$randomNumber:=(Random:C100%10)
$j:=0
While ($j<$randomNumber)
	For each ($item; $fakeComments)
		$comment:=ds:C1482.Comment.new()
		$comment.content:=$item.content
		$comment.creationDate:=$item.creationDate
		$comment.creationTime:=$item.creationTime
		$randomIndexArticle:=(Random:C100%$articles.length)
		$comment.article:=$articles[$randomIndexArticle]
		randomIndexUser:=(Random:C100%$users.length)
		$comment.user:=$users[randomIndexUser]
		$comment.save()
		$notification:=ds:C1482.Notification.generateNotifs($articles[$randomIndexArticle].user; $users[randomIndexUser]; $articles[$randomIndexArticle]; "comment")
	End for each 
	$j:=$j+1
End while 


