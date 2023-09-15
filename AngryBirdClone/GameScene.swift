//
//  GameScene.swift
//  AngryBirdClone
//
//  Created by Atil Samancioglu on 12.08.2019.
//  Copyright © 2019 Atil Samancioglu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //var bird2 = SKSpriteNode()
    
    var bird = SKSpriteNode() // kuş oluşturuyoruz
    var box1 = SKSpriteNode()
    var box2 = SKSpriteNode()
    var box3 = SKSpriteNode()
    var box4 = SKSpriteNode()
    var box5 = SKSpriteNode()
    
    var gameStarted = false // bu oluşturduğumuz değişken false ise sadece çekme işlemlerini yap değilse yapma diycez. yani oyun başladıysa çekme işlemini yapma
    
    var originalPosition : CGPoint?
    
    var score = 0
    var scoreLabel = SKLabelNode()
    
    enum ColliderType: UInt32 { // enumla kategori oluşturulur. UInt32 tipi seçildiği için başka case lerde olsaydı 2 nin üstleri şeklinde arttırmak gerekiyor. o anki case e kadar olan sayıların toplamından büyük olmalı
        case Bird = 1
        case Box = 2
      //case x = 4
      //case y = 8
    }

    override func didMove(to view: SKView) {
        /*
        let texture = SKTexture(imageNamed: "bird") // ilgili texture a bird görselini ver. kodla bird2 yi yapıyoruz
        bird2 = SKSpriteNode(texture: texture) // bird2 ye texture tanımlıyoruz
        bird2.position = CGPoint(x: -self.frame.width / 4, y: -self.frame.height / 4) // koordinat sisteminde nerede durucağı. burada self.frame.width bu şekilde demeyip mesela 50 yazsaydık da olurdu ama bu şekilde yazmak her farklı cihazın genişliğine göre hesaplama yaptığı için daha sağlıklı
        bird2.size = CGSize(width: self.frame.width / 16, height: self.frame.height / 10) // bird2 nin size ı
        bird2.zPosition = 1 // bird2 en önde dursun. backgrond -1, ağaç 0
        self.addChild(bird2)
 */
        
        //Physics Body
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame) // ekranın tamamını çembere alma. bunu yapınca yerçekimi olan ortamda kuş düştüğünde kaybolmuyo yerde duruyo
        self.scene?.scaleMode = .aspectFit // kuş yere düştüğünde gözükmüyordu. ekranı aspectFit e ayarlayınca artık gözüküyor
        self.physicsWorld.contactDelegate = self // bunu yapınca kontaktları algılama opsiyonumuz olucak. SKPhysicsContactDelegate ı class ın yanına ekliyoruz
        
        // Bird
        
        bird = childNode(withName: "bird") as! SKSpriteNode // gamescene içinde oluşturduğumuz bird ü buraya bu şekilde tanımlarız. bunu kodla yazmıyoken yaparız
        
        let birdTexture = SKTexture(imageNamed: "bird")
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 13) // PhysicsBody i etkileşim içerisine alıcak bir boyut istiyor. kuşun etrafında bir çember oluşturuyor PhysicsBody. kuşun etkileşime girdiği öyle anlaşılıyor. kuş yuvarlak olduğu için circleOfRadius i seçiyoruz.
        bird.physicsBody?.affectedByGravity = false // yer çekiminden etkilenmesin
        bird.physicsBody?.isDynamic = true // fiziksel simülasyonlardan etkilensin
        bird.physicsBody?.mass = 0.15 // kuşun kütlesini veriyoruz
        originalPosition = bird.position // kuş nerde duruyosa orijinal pozisyona da bu atanacak. bunu daha sonra kuşa dokunma bitince ne olucağı kısmında kullanıcaz
        
        bird.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue // contactTestBitMask bi kategori tanımladığımızda diğer taraflarla bi çakışma yaşandığında bize bir bildirim verir
        bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue // her görünümümüzü kategorize edicez. her görünüm kimle çarpışabilir onu söyliycez
        bird.physicsBody?.collisionBitMask = ColliderType.Box.rawValue // hangisiyle çarpışabilir. kuş kutuyla çarpışacak
        
        //Box
        
        let boxTexture = SKTexture(imageNamed: "brick")
        let size = CGSize(width: boxTexture.size().width / 6, height: boxTexture.size().height / 6) // bu sefer dikdörtgen olduğu için width ve height vermek gerek
        
        box1 = childNode(withName: "box1") as! SKSpriteNode // box1 i tanımlıyoruz
        box1.physicsBody = SKPhysicsBody(rectangleOf: size) // kutu dikdörtgene benzediği için rectangleOf seçiyoruz
        box1.physicsBody?.isDynamic = true
        box1.physicsBody?.affectedByGravity = true
        box1.physicsBody?.allowsRotation = true // kutuya bi şey çarptığında sağa sola dönsün
        box1.physicsBody?.mass = 0.4
        
        box1.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue // kutuyla kuşu çarpıştırıyoruz. bunu yazmasak da aslında kutuyla kuş çarpışıyodu ama çarpışmaları algılamak için yazmak gerek
        
        box2 = childNode(withName: "box2") as! SKSpriteNode
        box2.physicsBody = SKPhysicsBody(rectangleOf: size)
        box2.physicsBody?.isDynamic = true
        box2.physicsBody?.affectedByGravity = true
        box2.physicsBody?.allowsRotation = true
        box2.physicsBody?.mass = 0.4
        
        box2.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue

        
        box3 = childNode(withName: "box3") as! SKSpriteNode
        box3.physicsBody = SKPhysicsBody(rectangleOf: size)
        box3.physicsBody?.isDynamic = true
        box3.physicsBody?.affectedByGravity = true
        box3.physicsBody?.allowsRotation = true
        box3.physicsBody?.mass = 0.4
        
        box3.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue

        
        box4 = childNode(withName: "box4") as! SKSpriteNode
        box4.physicsBody = SKPhysicsBody(rectangleOf: size)
        box4.physicsBody?.isDynamic = true
        box4.physicsBody?.affectedByGravity = true
        box4.physicsBody?.allowsRotation = true
        box4.physicsBody?.mass = 0.4
        
        box4.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue

        
        box5 = childNode(withName: "box5") as! SKSpriteNode
        box5.physicsBody = SKPhysicsBody(rectangleOf: size)
        box5.physicsBody?.isDynamic = true
        box5.physicsBody?.affectedByGravity = true
        box5.physicsBody?.allowsRotation = true
        box5.physicsBody?.mass = 0.4
        box5.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue

     
        //Label
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height / 4)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
        
        
       
    }
    
    func didBegin(_ contact: SKPhysicsContact) { // kontakt(çarpışma) oldu
        
        if contact.bodyA.collisionBitMask == ColliderType.Bird.rawValue || contact.bodyB.collisionBitMask == ColliderType.Bird.rawValue { // iki farklı kategorinin çarpıştığını yazıyoruz
            
            score += 1 // çarpışma olunca skoru bir arttır
            scoreLabel.text = String(score)
            
        }
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // kullanıcı dokunmaya başladı
        /*
        bird.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 100)) // bir etki oluşturucaz ve bizden bir vektör istiyor. vektör x y ekseni belirtebileceğimiz bir obje. y değeri demek etkisi aşağıdan yukarıya 100 puan gidicek bir güç uygula demek. x 0 ken y ye değer verdiğimizde tıklandığında sadece y ekseninde hareket ediyor. x 50 yazınca kuş tıklanınca x ekseninde de hareket ediyor
        bird.physicsBody?.affectedByGravity = true // kuşa tıklandığında düşmesini istiyorsak true yaparız
 */
        if gameStarted == false {
            
            if let touch = touches.first { // touch ı alabilirsek diyoruz. touch ı alamayadabiliriz o yüzden if let kullanıyoruz
                
                let touchLocation = touch.location(in: self) // bize bir view soruyor. view ımıza self diyoruz
                let touchNodes = nodes(at: touchLocation) // dokunulan noktadaki touchLocation ı bana ver
                
                if touchNodes.isEmpty == false { // dokunulan bir node varsa
                    
                    for node in touchNodes { // for loop la dokunulan node ların hepsini alabiliriz. kuşa dokunuldu mu onu görmek istiyoruz
                        
                        if let sprite = node as? SKSpriteNode { // node u SKSpriteNode olarak cast etmeye çalış(SKSpriteNode kuşla aynı mı ona bakıyoruz)
                            if sprite == bird { //
                                bird.position = touchLocation // bird ün yeni pozisyonu dokunulan yer diyoruz. bunu sadece touchesBegan de yapmıyoruz diğer fonksiyonlarda da kullanıcaz çünkü kullanıcı sadece dokunup bırakmıycak harekete devam ettiricek
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { // kullanıcı hareket ettirmeye başladı
      if gameStarted == false {
          
          if let touch = touches.first {
              
              let touchLocation = touch.location(in: self)
              let touchNodes = nodes(at: touchLocation)
              
              if touchNodes.isEmpty == false {
                  
                  for node in touchNodes {
                      
                      if let sprite = node as? SKSpriteNode {
                          if sprite == bird {
                              bird.position = touchLocation
                          }
                      }
                  }
              }
          }
      }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { // dokunma bitti
        
        if gameStarted == false { // çekme işlemlerini yap diycez
        
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: self)
            let touchNodes = nodes(at: touchLocation)
            
            if touchNodes.isEmpty == false {
                
                for node in touchNodes {
                    
                    if let sprite = node as? SKSpriteNode {
                        if sprite == bird { // buradan sonra kuşu fırlatıcaz
                           
                            let dx = -(touchLocation.x - originalPosition!.x) // touchLocation la originalPosition arasındaki farkı alıcaz ve bunu bir impulse(etki) olarak vericez. - dersek tersi yöne gider
                            let dy = -(touchLocation.y - originalPosition!.y)
                            
                            let impulse = CGVector(dx: dx, dy: dy)
                            
                            bird.physicsBody?.applyImpulse(impulse)
                            bird.physicsBody?.affectedByGravity = true
                            
                            gameStarted = true // çekme işlemlerini yapma. bunu true yapalım ki tekrar kuşu havada tutamayalım
                        }
                    }
                }
            }
        }
    }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    
    override func update(_ currentTime: TimeInterval) { //  ekran devamlı değişirken bu fonksiyon çağırılır
        // Called before each frame is rendered
        
        if let birdPhysicsBody = bird.physicsBody {
            
            if birdPhysicsBody.velocity.dx <= 0.1 && birdPhysicsBody.velocity.dy <= 0.1 && birdPhysicsBody.angularVelocity <= 0.1 && gameStarted == true { // birdPhysicsBody nin velocity diyerek hızını kontrol ediyoruz. angularVelocity açısal hız demek. en son oyun da başladıysa diyoruz. yani oyun başlamış ve kuş durmak üzere. kuş belli bir hızın altına düştüğünde kuşu başlangıç yerine götür
                
                bird.physicsBody?.affectedByGravity = false
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.angularVelocity = 0
                bird.zPosition = 1
                bird.position = originalPosition!
                
                //score = 0 // bunu yazarsak oyun her başladığında score 0 gözükür
                //scoreLabel.text = String(score)
                
                gameStarted = false
            }
        }
    }
}
