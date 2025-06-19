//%attributes = {}
// general var
var $item: object
var $users: cs.UserSelection
var $tags: cs.TagSelection
var $categories: cs.CategorySelection
var $articles: cs.ArticleSelection
var $tagArticles: cs.ArticleTagSelection
var $notification: cs.Notification

var $image: picture
var $request: 4D.HTTPRequest

// Generate Users
var $user: cs.UserEntity
var $fakeUsers: collection
var $requestAvatar: 4D.HTTPRequest
var $avatar: picture
var $currentUser: object
var $usersInterface: cs.Qodly.Users
var $success: boolean

$usersInterface := cs.Qodly.Users.me
$currentUser := $usersInterface.currentUser()
if ($currentUser.email # null)
	$user := ds.User.query("email = :1"; $currentUser.email).first()
	if ($user = null)
		$success := ds.User.create($currentUser.email; $currentUser.firstname; $currentUser.lastname; $currentUser.role)
		if ($success)
			$user := ds.User.query("email = :1"; $currentUser.email).first()
		end if 
	end if 
	
	use (session.storage)
		session.storage.playload := new Shared Object("ID"; $user.ID; "email"; $user.email; "role"; $user.role)
	end use 
	session.setPrivileges($user.role)
end if 

$fakeUsers := []

$fakeUsers.push(\
new Object("lastname", "admin", "firstname", "admin", "email", "admin@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Laramée", "firstname", "Philip", "email", "philipe.laramee@4d.com", "creationDate", current Date, "role", "Learner"); \
new Object("lastname", "Devoe", "firstname", "Vail", "email", "Vail.Devoe@4d.com", "creationDate", current Date, "role", "Tutor")\)
$fakeUsers.push(\
new Object("lastname", "Smith", "firstname", "John", "email", "john.smith@4d.com", "creationDate", current Date, "role", "Learner"); \
new Object("lastname", "Johnson", "firstname", "Emily", "email", "emily.johnson@4d.com", "creationDate", current Date, "role", "Tutor"); \
new Object("lastname", "Brown", "firstname", "Michael", "email", "michael.brown@4d.com", "creationDate", current Date, "role", "Learner"); \
new Object("lastname", "Davis", "firstname", "Olivia", "email", "olivia.davis@4d.com", "creationDate", current Date, "role", "Tutor"); \
new Object("lastname", "Wilson", "firstname", "Daniel", "email", "daniel.wilson@4d.com", "creationDate", current Date, "role", "Tutor")\)
$fakeUsers.push(\
new Object("lastname", "Anderson", "firstname", "Sophia", "email", "sophia.anderson@4d.com", "creationDate", current Date, "role", "Tutor"); \
new Object("lastname", "Martinez", "firstname", "Liam", "email", "liam.martinez@4d.com", "creationDate", current Date, "role", "Learner"); \
new Object("lastname", "Garcia", "firstname", "Isabella", "email", "isabella.garcia@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Thomas", "firstname", "James", "email", "james.thomas@4d.com", "creationDate", current Date, "role", "Learner"); \
new Object("lastname", "Robinson", "firstname", "Ava", "email", "ava.robinson@4d.com", "creationDate", current Date, "role", "Tutor")\)
$fakeUsers.push(\
new Object("lastname", "Lee", "firstname", "Ethan", "email", "ethan.lee@4d.com", "creationDate", current Date, "role", "Tutor"); \
new Object("lastname", "Walker", "firstname", "Mia", "email", "mia.walker@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Hall", "firstname", "Noah", "email", "noah.hall@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Allen", "firstname", "Emma", "email", "emma.allen@4d.com", "creationDate", current Date, "role", "Tutor"); \
new Object("lastname", "Baker", "firstname", "Lucas", "email", "lucas.baker@4d.com", "creationDate", current Date, "role", "Tutor")\)
$fakeUsers.push(\
new Object("lastname", "Gonzalez", "firstname", "Sophie", "email", "sophie.gonzalez@4d.com", "creationDate", current Date, "role", "Learner"); \
new Object("lastname", "Clark", "firstname", "Alexander", "email", "alexander.clark@4d.com", "creationDate", current Date, "role", "Learner"); \
new Object("lastname", "Rodriguez", "firstname", "Chloe", "email", "chloe.rodriguez@4d.com", "creationDate", current Date, "role", "Tutor"); \
new Object("lastname", "Parker", "firstname", "William", "email", "william.parker@4d.com", "creationDate", current Date, "role", "Learner"); \
new Object("lastname", "Wright", "firstname", "Avery", "email", "avery.wright@4d.com", "creationDate", current Date, "role", "Learner")\)
$fakeUsers.push(\
new Object("lastname", "Adams", "firstname", "Grace", "email", "grace.adams@4d.com", "creationDate", current Date, "role", "Tutor"); \
new Object("lastname", "Cook", "firstname", "Logan", "email", "logan.cook@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Bell", "firstname", "Harper", "email", "harper.bell@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Diaz", "firstname", "Elijah", "email", "elijah.diaz@4d.com", "creationDate", current Date, "role", "Tutor"); \
new Object("lastname", "Stewart", "firstname", "Scarlett", "email", "scarlett.stewart@4d.com", "creationDate", current Date, "role", "Tutor")\)
$fakeUsers.push(\
new Object("lastname", "Rivera", "firstname", "Aiden", "email", "aiden.rivera@4d.com", "creationDate", current Date, "role", "Tutor"); \
new Object("lastname", "Price", "firstname", "Hannah", "email", "hannah.price@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Bailey", "firstname", "Nathan", "email", "nathan.bailey@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Cooper", "firstname", "Lily", "email", "lily.cooper@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Flores", "firstname", "Evelyn", "email", "evelyn.flores@4d.com", "creationDate", current Date, "role", "Admin")\)
$fakeUsers.push(\
new Object("lastname", "Chen", "firstname", "Liam", "email", "liam.chen@4d.com", "creationDate", current Date, "role", "Learner"); \
new Object("lastname", "Graham", "firstname", "Zoe", "email", "zoe.graham@4d.com", "creationDate", current Date, "role", "Learner"); \
new Object("lastname", "Perry", "firstname", "William", "email", "william.perry@4d.com", "creationDate", current Date, "role", "Tutor"); \
new Object("lastname", "Nguyen", "firstname", "Aria", "email", "aria.nguyen@4d.com", "creationDate", current Date, "role", "Learner"); \
new Object("lastname", "Reed", "firstname", "Gabriel", "email", "gabriel.reed@4d.com", "creationDate", current Date, "role", "Tutor")\)
$fakeUsers.push(\
new Object("lastname", "Carter", "firstname", "Ella", "email", "ella.carter@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Murphy", "firstname", "Jack", "email", "jack.murphy@4d.com", "creationDate", current Date, "role", "Tutor"); \
new Object("lastname", "Morris", "firstname", "Layla", "email", "layla.morris@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Brooks", "firstname", "Henry", "email", "henry.brooks@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Barnes", "firstname", "Grace", "email", "grace.barnes@4d.com", "creationDate", current Date, "role", "Admin")\)
$fakeUsers.push(\
new Object("lastname", "Powell", "firstname", "Lucas", "email", "lucas.powell@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Russell", "firstname", "Samantha", "email", "samantha.russell@4d.com", "creationDate", current Date, "role", "Tutor"); \
new Object("lastname", "Bryant", "firstname", "Mason", "email", "mason.bryant@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Foster", "firstname", "Madison", "email", "madison.foster@4d.com", "creationDate", current Date, "role", "Admin"); \
new Object("lastname", "Jenkins", "firstname", "Benjamin", "email", "benjamin.jenkins@4d.com", "creationDate", current Date, "role", "Tutor")\)

for Each ($item; $fakeUsers)
	$user := ds.User.new()
	$user.firstname := $item.firstname
	$user.lastname := $item.lastname
	$user.email := $item.email
	$user.password := Generate password hash("123456")
	$user.creationDate := $item.creationDate
	$user.role := $item.role
	$user.active := true
	$requestAvatar := 4D.HTTPRequest.new("https://picsum.photos/200").wait()
	if ($requestAvatar.response # null)
		BLOB TO PICTURE($requestAvatar.response.body; $avatar)
		$user.avatar := $avatar
	end if 
	$user.save()
end for each 

$users := ds.User.all()

// Generate Category
var $category: collection
var $cat: cs.CategoryEntity

$category := []
$category.push(\
new Object("label", "Software Development"); \
new Object("label", "Networking and Security"); \
new Object("label", "Cloud Computing"); \
new Object("label", "Testing"); \
new Object("label", "DevOps"); \
new Object("label", "Cloud Computing"); \
new Object("label", "Networking and Security"); \
new Object("label", "DevOps"); \
new Object("label", "Testing"); \
new Object("label", "Machine Learning"); \
new Object("label", "Data Science"); \
new Object("label", "Artificial Intelligence"); \
new Object("label", "Big Data"); \
new Object("label", "Cloud Computing"); \
new Object("label", "Big Data"); \
new Object("label", "Data Analytics"); \
new Object("label", "Business Intelligence"); \
new Object("label", "Data Visualization"); \
new Object("label", "Blockchain"); \
new Object("label", "Cryptocurrency"); \
new Object("label", "Web3"); \
new Object("label", "Decentralization"); \
new Object("label", "Fintech"); \
new Object("label", "Cybersecurity"); \
new Object("label", "Information Security"); \
new Object("label", "Network Security"); \
new Object("label", "Application Security"); \
new Object("label", "End-User Security"); \
new Object("label", "Web Development"); \
new Object("label", "Front-End Development"); \
new Object("label", "Back-End Development"); \
new Object("label", "Full-Stack Development"); \
new Object("label", "Mobile Development"); \
new Object("label", "UI/UX Design"); \
new Object("label", "Graphic Design"); \
new Object("label", "Product Design"); \
new Object("label", "Service Design"); \
new Object("label", "UX Research"); \
new Object("label", "Product Management"); \
new Object("label", "Project Management"); \
new Object("label", "Agile Development"); \
new Object("label", "Scrum"); \
new Object("label", "Kanban"); \
new Object("label", "Marketing"); \
new Object("label", "Sales"); \
new Object("label", "Growth Hacking"); \
new Object("label", "Object-Oriented Programming"); \
new Object("label", "Functional Programming"); \
new Object("label", "Procedural Programming"); \
new Object("label", "Imperative Programming"); \
new Object("label", "Declarative Programming"); \
new Object("label", "Event-Driven Programming"); \
new Object("label", "Logic Programming"); \
new Object("label", "Aspect-Oriented Programming"); \
new Object("label", "Concurrent Programming"); \
new Object("label", "Parallel Programming"); \
new Object("label", "Data-Driven Programming"); \
new Object("label", "Component-Based Programming"); \
new Object("label", "Service-Oriented Programming"); \
new Object("label", "Event-Driven Architecture"); \
new Object("label", "Microservices Architecture")\)

for Each ($item; $category)
	$cat := ds.Category.new()
	$cat.label := $item.label
	$cat.save()
end for each 

$categories := ds.Category.all()

// generate Tag
var $fakeTags: collection
var $tag: cs.TagEntity

$fakeTags := []
$fakeTags.push(\
new Object("label", "CodeRefactoring"); \
new Object("label", "SoftwareDevelopment"); \
new Object("label", "Maintenance"); \
new Object("label", "Performance"); \
new Object("label", "Algorithms"); \
new Object("label", "AgileDevelopment"); \
new Object("label", "DesignPatterns"); \
new Object("label", "Debugging"); \
new Object("label", "Troubleshooting"); \
new Object("label", "UnitTesting"); \
new Object("label", "Containerization"); \
new Object("label", "Docker"); \
new Object("label", "iOSDevelopment"); \
new Object("label", "AndroidDevelopment"); \
new Object("label", "CrossPlatformDevelopment"); \
new Object("label", "MobileAppDesign"); \
new Object("label", "MobileAppTesting"); \
new Object("label", "AppSecurity"); \
new Object("label", "AppPerformance"); \
new Object("label", "PushNotifications"); \
new Object("label", "InAppPurchases"); \
new Object("label", "MobileAppAnalytics"); \
new Object("label", "AugmentedReality"); \
new Object("label", "AppPublishing")\)

for Each ($item; $fakeTags)
	$tag := ds.Tag.new()
	$tag.label := $item.label
	$tag.save()
end for each 
$tags := ds.Tag.all()

// Generate Articles

var $fakeArticles: collection
var $article: cs.ArticleEntity
var $randomNums: integer
$fakeArticles := []

$fakeArticles.push(\
new Object("title"; "The Art of Code Refactoring"; \
"content"; "In this article; we explore the importance of code refactoring in software development. Code refactoring is the process of restructuring existing code to improve its readability; maintainability; and performance. We discuss various refactoring techniq"+"ues; best practices; and tools that developers can use to efficiently refactor their code and create a more robust software system."; \
"creationDate"; current Date(); \
"creationTime"; time(2000); \
"public"; false; \
"status"; false)\
)

$fakeArticles.push(\
new Object("title"; "Continuous Integration and Deployment with Jenkins"; \
"content"; "Continuous integration and deployment are essential practices in modern software development. This article focuses on Jenkins; a widely used automation server; and how it enables seamless integration; testing; and deployment of code changes. We walk t"+"hrough the setup of Jenkins pipelines; integration with version control systems; and automating the deployment process."; \
"creationDate"; current Date(); \
"creationTime"; time(1000); \
"public"; false; \
"status"; true)\
)

$fakeArticles.push(\
new Object("title"; "Agile Software Development: Scrum in Action"; \
"content"; "Agile software development methodologies; like Scrum; have gained immense popularity in recent years. In this article; we delve into the principles of Scrum and its practical implementation in software projects. We cover the roles of Scrum Master; Pro"+"duct Owner; and Development Team; as well as the Scrum events and artifacts that facilitate effective project management and delivery."; \
"creationDate"; current Date(); \
"creationTime"; time(4000); \
"public"; false; \
"status"; false)\
)

$fakeArticles.push(\
new Object("title"; "Web application security is a critical aspect of software engineering."; \
"content"; "In this article; we highlight the best practices for securing web applications against common vulnerabilities such as SQL injection; cross-site scripting (XSS); and cross-site request forgery (CSRF). We also discuss the importance of input validation; "+" authentication; and authorization in building secure web applications."; \
"creationDate"; current Date(); \
"creationTime"; time(3000); \
"public"; true; \
"status"; true)\
)

$fakeArticles.push(\
new Object("title"; "Getting Started with React: Building Dynamic User Interfaces."; \
"content"; "React has become one of the most popular JavaScript libraries for building user interfaces. In this article; we provide a beginner-friendly guide to React; explaining its component-based architecture and how to create dynamic and interactive user inte"+"rfaces using React's state and props. We also introduce key concepts like JSX; virtual DOM; and React hooks."; \
"creationDate"; current Date(); \
"creationTime"; time(5000); \
"public"; false; \
"status"; false)\
)

$fakeArticles.push(\
new Object("title"; "Exploring Microservices Architecture for Scalable Applications"; \
"content"; "Microservices architecture has revolutionized the way we design and develop scalable applications. In this article; we discuss the concepts behind microservices; their benefits; and the challenges they pose. We explore how to break down monolithic app"+"lications into microservices; manage communication between them; and deploy them using containerization technologies like Docker and Kubernetes."; \
"creationDate"; current Date(); \
"creationTime"; time(3200); \
"public"; true; \
"status"; true)\
)

$fakeArticles.push(\
new Object("title"; "Understanding Design Patterns: Building Reusable Software Components"; \
"content"; "Design patterns are crucial for building maintainable and reusable software components. In this article; we explore common design patterns like Singleton; Factory Method; Observer; and Strategy; explaining their purposes and use cases. Understanding t"+"hese patterns empowers developers to architect scalable and flexible software systems."; \
"creationDate"; current Date(); \
"creationTime"; time(5000); \
"public"; true; \
"status"; true)\
)

$fakeArticles.push(\
new Object("title"; "Debugging Techniques for Efficient Software Development"; \
"content"; "Debugging is an essential skill for software engineers to identify and fix defects in their code. In this article; we present various debugging techniques and tools that can help streamline the debugging process. We cover techniques like logging; unit"+" testing; and using debugging tools like debuggers and profilers to troubleshoot issues effectively."; \
"creationDate"; current Date(); \
"creationTime"; time(8000); \
"public"; false; \
"status"; false)\
)

$fakeArticles.push(\
new Object("title"; "Test-Driven Development (TDD): Building Quality Software from the Start"; \
"content"; "Test-Driven Development (TDD) has gained popularity as a software development approach that emphasizes writing tests before writing the actual code. In this article; we delve into the principles of TDD; its benefits in ensuring code quality and mainta"+"inability; and best practices for implementing TDD in your development workflow."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "16:00:00"; \
"public"; false; \
"status"; null)\
)

$fakeArticles.push(\
new Object("title"; "The Rise of DevOps: Bridging the Gap between Development and Operations"; \
"content"; "DevOps has revolutionized the software development and deployment process by bringing developers and operations teams closer together. This article explores the principles of DevOps; its impact on software delivery; and how it fosters collaboration; a"+"utomation; and continuous integration/continuous deployment (CI/CD) pipelines."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "16:30:00"; \
"public"; false; \
"status"; true)\
)

$fakeArticles.push(\
new Object("title"; "Microservices Architecture: Building Scalable and Agile Systems"; \
"content"; "Microservices architecture has become a preferred approach for building complex and scalable software systems. This article examines the key concepts behind microservices; the benefits of decoupling services; and the challenges and best practices in a"+"dopting this architecture."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "17:00:00"; \
"public"; false; \
"status"; null)\
)

$fakeArticles.push(\
new Object("title"; "The Role of Artificial Intelligence in Software Engineering"; \
"content"; "Artificial Intelligence (AI) is transforming the software engineering landscape; from code generation to automated testing and debugging. In this article; we explore how AI is reshaping the way developers write code; optimize performance; and enhance "+"user experiences."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "17:30:00"; \
"public"; false; \
"status"; true)\
)

$fakeArticles.push(\
new Object("title"; "Security in Software Development: Best Practices for Fortifying Your Applications"; \
"content"; "Security is paramount in software development; given the increasing integer of cyber threats. This article covers essential security best practices; such as input validation; authentication; and secure coding; to protect your applications from vulnerab"+"ilities and attacks."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "18:00:00"; \
"public"; false; \
"status"; true)\
)

$fakeArticles.push(\
new Object("title"; "Continuous Integration and Continuous Deployment (CI/CD): Streamlining Software Delivery"; \
"content"; "CI/CD practices enable developers to continuously integrate code changes and deploy updates to production efficiently. This article discusses the benefits of CI/CD; popular tools; and how it accelerates the development lifecycle while ensuring code qu"+"ality and stability."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "18:30:00"; \
"public"; false; \
"status"; null)\
)

$fakeArticles.push(\
new Object("title"; "The Power of Drag and Drop: Simplifying User Interactions in Software"; \
"content"; "Drag and drop functionality has transformed the way users interact with software applications. This article explores the benefits of drag and drop interfaces; their impact on user experience; and how developers can implement this intuitive feature in "+"their applications to enhance usability."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "19:00:00"; \
"public"; true; \
"status"; true)\
)

$fakeArticles.push(\
new Object("title"; "Efficiency and Productivity: How Drag and Drop Editors Revolutionize Web Design"; \
"content"; "Web designers can now streamline their workflows and boost productivity with the help of drag and drop editors. This article explores the advantages of using drag and drop tools in web design; their impact on design iterations; and how designers can c"+"reate stunning websites without extensive coding knowledge."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "20:00:00"; \
"public"; false; \
"status"; null)\
)

$fakeArticles.push(\
new Object("title"; "Creating Customizable Workflows with Drag and Drop Software Builders"; \
"content"; "Drag and drop software builders have made it easier for non-technical users to create customizable workflows and applications. In this article; we examine the capabilities of drag and drop builders; their role in empowering users; and some popular pla"+"tforms that enable users to build powerful applications without coding."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "19:30:00"; \
"public"; false; \
"status"; true)\
)

$fakeArticles.push(\
new Object("title"; "The Evolution of Software Development Methodologies"; \
"content"; "In this article; we explore the history and evolution of software development methodologies; from the traditional Waterfall approach to Agile; Scrum; and Kanban. We discuss the advantages and disadvantages of each methodology and how they have shaped "+"the way software is built and delivered today."; \
"creationDate"; "2023-07-23"; \
"creationTime"; "15:30:00"; \
"public"; false; \
"status"; true)\
)

$fakeArticles.push(\
new Object("title"; "Introduction to Blockchain Technology: Building Decentralized Applications"; \
"content"; "Blockchain technology is disrupting various industries with its decentralized and transparent nature. In this article; we introduce the fundamentals of blockchain; exploring concepts like distributed ledgers; smart contracts; and consensus mechanisms."+" We also discuss how to develop decentralized applications (DApps) using popular blockchain platforms like Ethereum."; \
"creationDate"; current Date(); \
"creationTime"; time(3000); \
"public"; true; \
"status"; true)\
)

$fakeArticles.push(\
new Object("title"; "The Power of Cloud Computing in Modern Business"; \
"content"; "Cloud computing has revolutionized the way businesses operate. In this article; we delve into the various benefits of cloud computing; such as cost savings; scalability; and increased efficiency. We also examine real-world case studies of businesses l"+"everaging cloud technology to gain a competitive edge in their industries."; \
"creationDate"; "2023-07-24"; \
"creationTime"; "10:15:00"; \
"status"; false)\
)

$fakeArticles.push(\
new Object("title"; "The Rise of Artificial Intelligence in Healthcare"; \
"content"; "Artificial Intelligence (AI) is transforming the healthcare industry. From diagnosis and treatment to drug discovery and personalized medicine; AI is making significant strides. In this article; we explore the applications of AI in healthcare and its "+"potential to revolutionize patient care; improve outcomes; and reduce costs."; \
"creationDate"; "2023-07-24"; \
"creationTime"; "14:00:00"; \
"public"; false; \
"status"; true)\
)

$fakeArticles.push(\
new Object("title"; "The Future of Blockchain Technology in Finance"; \
"content"; "Blockchain technology is disrupting the financial sector in unprecedented ways. This article dives into how blockchain enables secure and transparent transactions; eliminates intermediaries; and enhances financial inclusion. We also discuss potential "+"challenges and regulatory considerations as blockchain continues to shape the future of finance."; \
"creationDate"; "2023-07-25"; \
"creationTime"; "09:45:00"; \
"public"; false; \
"status"; null)\
)

$fakeArticles.push(\
new Object("title"; "UX Design: Creating Exceptional User Experiences"; \
"content"; "User Experience (UX) design is a critical aspect of product development. In this article; we explore the principles of effective UX design; usability testing; and the impact of UX on customer satisfaction and retention. We also highlight the role of U"+"X in driving business success and share insights from industry experts on best practices."; \
"creationDate"; "2023-07-25"; \
"creationTime"; "13:20:00"; \
"public"; false; \
"status"; true)\
)

$fakeArticles.push(\
new Object("title"; "The Cybersecurity Landscape: Challenges and Solutions"; \
"content"; "With the increasing frequency and sophistication of cyber-attacks; cybersecurity has become paramount for organizations. This article examines the current cybersecurity landscape; major threats; and common vulnerabilities. We delve into proactive meas"+"ures like ethical hacking; AI-powered security tools; and employee training to defend against cyber threats."; \
"creationDate"; "2023-07-26"; \
"creationTime"; "11:10:00"; \
"public"; false; \
"status"; true)\
)

var $usersFilter: cs.UserSelection
$usersFilter := ds.User.query("role = :1 || role = :2"; "Admin"; "Tutor")

for Each ($item; $fakeArticles)
	
	$article := ds.Article.new()
	$article.title := $item.title
	$article.content := $item.content
	$article.creationDate := $item.creationDate
	$article.creationTime := $item.creationTime
	$article.published := $item.status
	$article.public := $item.public
	$randomNums := (random%$usersFilter.length)
	$article.user := $usersFilter[$randomNums]
	$randomNums := (random%$categories.length)
	$article.category := $categories[$randomNums]
	
	$request := 4D.HTTPRequest.new("https://picsum.photos/300/600").wait()
	if ($request.response # null)
		BLOB TO PICTURE($request.response.body; $image)
		$article.picture := $image
	end if 
	
	$article.save()
end for each 

$articles := ds.Article.all()

//Generate ArticleTag
var $tagArticle: cs.ArticleTagEntity
var $randomIndex: integer
var $i; j: integer
for ($i; 0; $articles.length-1)
	j := (random%3)+1
	while ((1 <= j) && (j <= 3))
		$tagArticle := ds.ArticleTag.new()
		$tagArticle.article := $articles[$i]
		$randomIndex := (random%$tags.length)
		$tagArticle.tag := $tags[$randomIndex]
		$tagArticle.save()
		j := j+1
	end while 
end for 

$tagArticles := ds.ArticleTag.all()

// Generate Likes
var $like: cs.LikeEntity
var $randomNumber: integer

$randomNumber := (random%10)
j := 0
while (j < $randomNumber)
	for ($i; 0; $users.length-1)
		$like := ds.Like.new()
		$like.likeDate := current Date
		$like.likeTime := current Time
		$like.likedBy := $users[$i]
		$randomIndex := (random%$articles.length)
		$like.article := $articles[$randomIndex]
		$like.save()
		$notification := ds.Notification.generateNotifs($articles[$randomIndex].user; $users[$i]; $articles[$randomIndex]; "like")
	end for 
	j := j+1
end while 

//Generate Comment
var $fakeComments: collection
var $randomIndexArticle; randomIndexUser: integer
var $comment: cs.CommentEntity

$fakeComments := []
$fakeComments.push(\
new Object("content"; "Great article! I love how it delves into the topic without overwhelming the reader with technical jargon. Looking forward to more content like this!"; "creationDate"; current Date(); "creationTime"; "00:02:12"), \
new Object("content"; "Your articles are like a treasure trove of knowledge. I find myself coming back for more every time!"; "creationDate"; current Date(); "creationTime"; "19:00:05"), \
new Object("content"; "Your writing is so engaging that I lose track of time while reading your articles. Keep up the fantastic work!"; "creationDate"; current Date(); "creationTime"; "21:20:15"), \
new Object("content"; "I'm a teacher; and your articles have become a valuable resource in my classroom. My students love them too!"; "creationDate"; current Date(); "creationTime"; "23:10:30"), \
new Object("content"; "You have a knack for explaining complex concepts with real-life examples. It makes learning a breeze!"; "creationDate"; current Date(); "creationTime"; "01:45:00"), \
new Object("content"; "I'm amazed by the depth of knowledge you share in your articles. You're a true expert in your field!"; "creationDate"; current Date(); "creationTime"; "03:25:12"), \
new Object("content"; "Your passion for education and your readers' success is evident in every word you write. Truly inspiring!"; "creationDate"; current Date(); "creationTime"; "05:12:38"), \
new Object("content"; "I often struggle with technical topics; but your articles make them accessible and enjoyable. Thank you!"; "creationDate"; current Date(); "creationTime"; "07:08:55"), \
new Object("content"; "Hmm; I feel like the article could use more examples to support the main points. Nevertheless; it's well-written and informative"; "creationDate"; current Date(); "creationTime"; "00:02:12"), \
new Object("content"; "Your articles have become my go-to resource whenever I need to understand a new subject. Invaluable!"; "creationDate"; current Date(); "creationTime"; "09:35:20"), \
new Object("content"; "I've shared your articles with my colleagues; and they're all amazed by the clarity and depth of your explanations."; "creationDate"; current Date(); "creationTime"; "11:40:10"), \
new Object("content"; "Your articles are not only informative but also enjoyable to read. You make learning a pleasure!"; "creationDate"; current Date(); "creationTime"; "13:55:55"), \
new Object("content"; "Your articles have ignited a passion for learning in me. I can't thank you enough for the inspiration!"; "creationDate"; current Date(); "creationTime"; "15:20:18"), \
new Object("content"; "Your enthusiasm for sharing knowledge is contagious. I feel energized to pursue my educational goals!"; "creationDate"; current Date(); "creationTime"; "05:25:15"), \
new Object("content"; "The structure of the article is on point! Clear introduction; logical flow; and a solid conclusion. Well done"; "creationDate"; current Date(); "creationTime"; "00:02:12"), \
new Object("content"; "I always look forward to your articles because I know they will be informative; engaging; and well-written."; "creationDate"; current Date(); "creationTime"; "17:15:30"), \
new Object("content"; "Your ability to simplify complex ideas is remarkable. You make learning challenging topics feel achievable."; "creationDate"; current Date(); "creationTime"; "19:10:45"), \
new Object("content"; "As a fellow educator; I admire your dedication to spreading knowledge. Your articles are a valuable resource!"; "creationDate"; current Date(); "creationTime"; "21:30:05"), \
new Object("content"; "Your articles are like a beacon of light in the vast sea of information. I'm grateful for your guidance."; "creationDate"; current Date(); "creationTime"; "23:45:22"), \
new Object("content"; "Your articles have become a staple in my learning journey. They've transformed me from a novice to a confident learner!"; "creationDate"; current Date(); "creationTime"; "01:18:08"), \
new Object("content"; "I've learned more from your articles than from any expensive course. You're making education accessible to all!"; "creationDate"; current Date(); "creationTime"; "03:50:40"), \
new Object("content"; "As someone new to article writing; this was a helpful read. It provided practical tips that I can implement in my own work. Thanks!"; "creationDate"; current Date(); "creationTime"; "00:02:12"), \
new Object("content"; "Your articles are like a breath of fresh air. They make complex topics feel fascinating and approachable."; "creationDate"; current Date(); "creationTime"; "07:30:30"), \
new Object("content"; "I've recommended your articles to my friends; and they all share my excitement for the wealth of insights you offer."; "creationDate"; current Date(); "creationTime"; "09:15:55"), \
new Object("content"; "Your articles have changed the way I approach learning. I now see it as a journey of self-discovery."; "creationDate"; current Date(); "creationTime"; "19:55:05"), \
new Object("content"; "I'm amazed at how you manage to make seemingly boring topics so engaging and relevant. Bravo!"; "creationDate"; current Date(); "creationTime"; "01:08:50"), \
new Object("content"; "I appreciate the effort to cite sources; but some of the links seem outdated. It would be great if the author could update them."; "creationDate"; current Date(); "creationTime"; "00:02:12"), \
new Object("content"; "Your articles are like a knowledge buffet - I can't get enough! Each one leaves me hungry for more learning."; "creationDate"; current Date(); "creationTime"; "11:00:05"), \
new Object("content"; "I've never been so excited about learning before! Your articles make complex topics feel like an adventure."; "creationDate"; current Date(); "creationTime"; "13:20:18"), \
new Object("content"; "Your dedication to sharing knowledge is admirable. You're empowering learners all around the world."; "creationDate"; current Date(); "creationTime"; "15:10:30"), \
new Object("content"; "I've found answers to questions I didn't even know I had in your articles. Truly eye-opening and enriching!"; "creationDate"; current Date(); "creationTime"; "17:25:22"), \
new Object("content"; "Your articles are like a mentor guiding me on my learning journey. I couldn't ask for a better teacher!"; "creationDate"; current Date(); "creationTime"; "19:45:40"), \
new Object("content"; "I've been recommending your articles to my colleagues at work; and they're equally impressed!"; "creationDate"; current Date(); "creationTime"; "21:35:55"), \
new Object("content"; "Nice article! But could you provide more in-depth explanations of certain concepts? I'm hungry for more knowledge!"; "creationDate"; current Date(); "creationTime"; "00:02:12"), \
new Object("content"; "Your passion for education is evident in every sentence. Your articles motivate me to be a lifelong learner."; "creationDate"; current Date(); "creationTime"; "23:20:10"), \
new Object("content"; "Your articles strike the perfect balance between simplicity and depth. They cater to learners of all levels."; "creationDate"; current Date(); "creationTime"; "01:15:38"), \
new Object("content"; "I was struggling with self-study; but your articles have given me the confidence to learn independently."; "creationDate"; current Date(); "creationTime"; "03:40:05"), \
new Object("content"; "Your articles are my go-to resource whenever I encounter a new subject. They're like my virtual tutor!"; "creationDate"; current Date(); "creationTime"; "05:55:20"), \
new Object("content"; "Great work! I love how you explained the complex topic in a simple and easy-to-understand way."; "creationDate"; current Date(); "creationTime"; "01:30:45"), \
new Object("content"; "This article is so insightful. I've learned a lot from reading it. Thank you for sharing your knowledge!"; "creationDate"; current Date(); "creationTime"; "09:15:20"), \
new Object("content"; "I'm a fan of your work. The depth of analysis you provide is unparalleled. Keep it up!"; "creationDate"; current Date(); "creationTime"; "12:10:10"), \
new Object("content"; "Your articles are fantastic! They provide a clear and comprehensive overview of the topic."; "creationDate"; current Date(); "creationTime"; "14:25:30"), \
new Object("content"; "I appreciate the effort you put into writing these articles. They are always informative and well-researched."; "creationDate"; current Date(); "creationTime"; "16:00:50"), \
new Object("content"; "Thank you for the insightful article. Your writing style makes complex subjects easy to grasp."; "creationDate"; current Date(); "creationTime"; "18:35:12"), \
new Object("content"; "I found this article very helpful. It clarified many doubts I had about the topic."; "creationDate"; current Date(); "creationTime"; "21:50:30")\
)

$randomNumber := (random%10)
j := 0
while (j < $randomNumber)
	for Each ($item; $fakeComments)
		$comment := ds.Comment.new()
		$comment.content := $item.content
		$comment.creationDate := $item.creationDate
		$comment.creationTime := $item.creationTime
		$randomIndexArticle := (random%$articles.length)
		$comment.article := $articles[$randomIndexArticle]
		randomIndexUser := (random%$users.length)
		$comment.user := $users[randomIndexUser]
		$comment.save()
		$notification := ds.Notification.generateNotifs($articles[$randomIndexArticle].user; $users[randomIndexUser]; $articles[$randomIndexArticle]; "comment")
	end for each 
	j := j+1
end while 


