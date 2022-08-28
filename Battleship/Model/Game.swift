/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Nguyen Phuoc Nhu Phuc
  ID: 3819660
  Created  date: 14/08/2022
  Last modified: 28/08/2022
  Acknowledgement:
 
*/

import Foundation
import Combine
import FirebaseCore
import FirebaseFirestore

/*
 The classic Battleship game
 */
final class Game: ObservableObject {
    static let numCols = 10
    static let numRows = 10
//    static let numCols = 6
//    static let numRows = 6
    var ocean: Ocean
    var fleet: Fleet // Bot's fleet
    var fleet2: Fleet // My fleet
    
    // Game state
    @Published var zoneStates = [[OceanZoneState]]()
    @Published var message = ""
    @Published var isMyTurn = true
    
    // Is game over
    var over: Bool {return fleet.isDestroyed()}
    var botWin: Bool {return fleet2.isDestroyed()} // game is over when player wins or bot wins
    
    // Player's score
    var isNavigatedBack = false
    var username = ""
    var isLoggedIn = false
    var myScore = 0
    var leaderboard = [User]()
    
    // Bot's last hits
    var botLastHits = [Coordinate]()
    var botLastHitShips:[(name: String, coordinates: [Coordinate])] = [("PT Boat", [Coordinate]()),
                                                          ("Submarine", [Coordinate]()),
                                                          ("Destroyer", [Coordinate]()),
                                                          ("Battleship", [Coordinate]()),
                                                          ("Aircraft Carrier", [Coordinate]())]
    var botLastHitShipName = ""
    var botMoveCombinations = [[Coordinate]]()
    
    // Difficulty level 0, 1, 2
    var difficultyLevel = 2
    
    // Previous zone states
    var prevZoneStates = [[OceanZoneState]]()
    
    /*
     Init game
     */
    init() {
        self.ocean = Ocean(numCols: Game.numCols, numRows: Game.numRows)
        self.fleet = Fleet()
        self.fleet2 = Fleet(isBot: false)
        reset() // refactor: reset when open Game view instead of when init Game object
        
        // load prev zone states
        fetchStateFromFirestore()
    }
    
    /*
     start a new game
     */
    func reset() {
        self.zoneStates = defaultZoneStates()
        self.fleet.deploy(on: self.ocean)
        self.message = ""
        // reset isMyTurn
        isMyTurn = true
        
        // deploy bot fleet
        let opponentCoordinates: [Coordinate] = self.fleet.coordinates()
        // pass opponent coordinates so that player can deploy ship without intersecting
        self.fleet2.deployPlayerFleet(on: self.ocean, opponentCoordinates: opponentCoordinates)
        
        // set zone state Ship at player's coordinates
        for e in self.fleet2.coordinates() {
            zoneStates[e.x][e.y] = .myCompartment
        }
        
        // Reset Bot's last hit ships
        self.resetBotLastHitShips()
        self.botMoveCombinations.removeAll()
    }
    
    /*
     Fetch game state from Firestore
     */
    func fetchStateFromFirestore() {
        if self.username.isEmpty {
            self.prevZoneStates = [[OceanZoneState]]()
            return
        }
        
        let docRef = db.collection("users").document(self.username)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let state = document.get("state") as? String else {
                    print("Cannot parse Game state from document")
                    self.prevZoneStates = [[OceanZoneState]]()
                    return
                }
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
                
                // Get zone state arr
                let arr = self.jsonToArr(jsonStr: state)
                
                // Load previous zone states
//                self.zoneStates = self.parseZoneStates(stateArr: prevState)
                self.prevZoneStates = self.parseZoneStates(stateArr: arr)
                self.zoneStates = self.prevZoneStates
                
                // TODO: Load my fleet from Firebase
                guard let myFleet = document.get("myFleet") as? String else {
                    print("line 121 Cannot parse myFleet from document")
                    return
                }

                self.fleet2 = self.jsonToFleet(jsonStr: myFleet)
                guard let botFleet = document.get("botFleet") as? String else {
                    print("line 121 Cannot parse botFleet from document")
                    return
                }

                self.fleet = self.jsonToFleet(jsonStr: botFleet)
                
                guard let score = document.get("score") as? Int else {
                    print("line 141 Cannot parse Score from document")
                    self.myScore = 0
                    return
                }

                // Update my score
                self.myScore = score
//                print("line 151 myscore", self.myScore)
            } else {
                self.prevZoneStates = [[OceanZoneState]]()
                print("Document does not exist")
            }
        }
    }
    
    /*
     Fetch leaderboard
     */
    func fetchLeaderboard() {
        db.collection("users").order(by: "score", descending: true).limit(to: 20)
            .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        // Clear leaderboard
                        self.leaderboard.removeAll()
                        
                        for document in querySnapshot!.documents {
//                            print("\(document.documentID) => \(document.data())")
                            guard let score = document.get("score") as? Int else {
                                print("Cannot parse Leaderboard score from document")
                                return
                            }
                            
//                            print("document name \(document.documentID), score=\(score)")
                            self.leaderboard.append(User(id: self.leaderboard.count, username: document.documentID, score: score, image: "avatar_\(Int.random(in: 1..<6))"))
                        }
                    }
            }
    }
    
    /*
     Update leaderboard
     */
    func updateLeaderboard(username: String, score: Int) {
        guard let userIndex = leaderboard.firstIndex(where: {$0.username == username}) else {
            print("Cannot update leaderboard. User does not exist in leaderboard")
            return
        }
        leaderboard[userIndex].score = score
        
        let sortedUsers = leaderboard.sorted {
            $0.score > $1.score
        }
        leaderboard = sortedUsers
    }
    
    func jsonToFleet(jsonStr: String) -> Fleet {
        let jsonData = Data(jsonStr.utf8)
        let parsedData = try! JSONDecoder().decode(Fleet.self, from: jsonData)
//        print("line 167 parsedData", parsedData.ships)
        return parsedData
    }
    
    func jsonToArr(jsonStr: String) -> [[Int]] {
        let jsonData = Data(jsonStr.utf8)
        let parsedData = try! JSONDecoder().decode([[Int]].self, from: jsonData)
        
        return parsedData
    }
    
    /*
     handle when an OceanZoneView is tapped
     */
    func zoneTapped(_ location: Coordinate) {
        //if we already tapped this location or the game is over, just ignore it
        if ((zoneStates[location.x][location.y] != .clear) || over || (zoneStates[location.x][location.y] == .myCompartment)) {
            print("invalid tap, tap again")
            playSound(sound: "invalid", type: "wav")
            return
        }
        
        //see if we hit a ship
        if let hitShip = fleet.ship(at: location) {
            hitShip.hit(at: location)
            zoneStates[location.x][location.y] = .hit
            message = hitShip.isSunk() ? "You sunk their \(hitShip.name)!" : "You Hit"
            
            playSound(sound: "explosion", type: "wav")
        } else {
            zoneStates[location.x][location.y] = .miss
            message = "You Miss"
        }
        
        //are we done?
        if (over) {
            message += " YOU WIN!"
            self.myScore += 1
            playSound(sound: "win", type: "wav")
            return
        }
        
        // turn off the 2 lines below to disable bot
        isMyTurn = false
        // isBotValidMove => getAdjacentMove => getBotNextMove => generateBotMove => placeBotMove
        placeBotMove()
    }
    
    // Place bot move on the Ocean
    func placeBotMove() {
//        print("Bot's turn")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Generate Bot's move
            let location = self.generateBotMove()

            //if we already tapped this location or the game is over, just ignore it
            if (((self.zoneStates[location.x][location.y] != .clear)
                 && (self.zoneStates[location.x][location.y] != .myCompartment))
                || self.botWin) {
                return
            }
    
            //see if we hit a ship
            if let hitShip = self.fleet2.ship(at: location) {
                hitShip.hit(at: location)
                self.zoneStates[location.x][location.y] = .opponentHit
//                print("line 174 self.zoneStates[location.x][location.y]", self.zoneStates[location.x][location.y])
                self.message = hitShip.isSunk() ? "Bot sunk your \(hitShip.name)!" : "Bot Hit"
                
                
                
                // TODO: Save to last hit location
                // find all coordinates of ship and append to botLastHitShip
                // after sunking a ship, clear botLastHitShip
                self.botLastHits.append(location)
                // Update botLastHitShips
                self.updateBotLastHitShips(shipName: hitShip.name, location: location)

                if hitShip.isSunk() {
                    self.botMoveCombinations.removeAll()
                } else {
                    if self.botMoveCombinations.isEmpty {
                        self.botMoveCombinations = self.getCombinations(location: location, numOfCompartments: self.getNumOfCompartments(shipName: hitShip.name))
                    }
                }
//                print("line 227, botMoveCombinations=", self.botMoveCombinations)
                
                
                
            } else {
                self.zoneStates[location.x][location.y] = .opponentMiss
                self.message = "Bot Miss"
            }

            //are we done?
            if (self.botWin) {
                self.message += " BOT WIN!"
                playSound(sound: "lose", type: "wav")
                return // end game so player can no longer tap
            }
            
            // Toggle isMyTurn
            self.isMyTurn = true
        }
    }
    
    // generate bot move regarding to difficulty level (give bot hints)
    func generateBotMove() -> Coordinate {
        var location = Coordinate(x: 0, y: 0)
        
        // Bot doesn't know where my ships are
        // Random bot move
        if ((difficultyLevel < 2) && (Int.random(in: 0..<100) <= (difficultyLevel == 0 ? 50 : 35))) {
            location = getConsecutiveStep()
        } else { 
            location = getBotNextMove()
            while (!isBotValidMove(x: location.x, y: location.y)) {
                location = getBotNextMove()
            }
        }
        
        return location
    }
    
    func getConsecutiveStep() -> Coordinate {
        var location = Coordinate(x: 0, y: 0)
        var found = false
        for (i, x) in self.zoneStates.enumerated() {
            for (j, y) in x.enumerated() {
                // bot cannot hit their own ship
                let coordinates = self.fleet.ships.map {$0.compartments.map {$0.location}}
                location.x = i
                location.y = j
                if ((y == .clear || y == .myCompartment) && (!Array(coordinates.joined()).contains(location))) {
//                    if (y == .myCompartment) { //bot always wins
//                        print([i, j])
                    location.x = i
                    location.y = j
                    found = true
                    break
                }
            }
            
            if found {
                break
            }
        }
        
        return location
    }
    
    /*
     TODO: delete combination when 1 move doesn't work (optional)
     */
    /*
     TODO: Bot has flaws: 2 hits in a row with the second hit belonging to another ship will calculate wrong next combinations
     => use botLastHitShips2 to fix
     */
    // Get bot next move (skipping)
    func getNextStep() -> Coordinate {
        var location = Coordinate(x: 0, y: 0)
        // if bot just hit
        // search for adjacent locations

            // get random (i + j) % 2 == 0 location
            var found = false
            for (i, x) in self.zoneStates.enumerated() {
                for (j, y) in x.enumerated() where ((i + j) % 2 == 0) {
                    // bot cannot hit their own ship
                    let coordinates = self.fleet.ships.map {$0.compartments.map {$0.location}}
                    location.x = i
                    location.y = j

                    if ((y == .clear || y == .myCompartment) && (!Array(coordinates.joined()).contains(location))) {
//                    if (y == .myCompartment) { //bot always wins
                        location.x = i
                        location.y = j
                        found = true
                        break
                    }
                }

                if found {
                    break
                }
            }
        
        
        return location
    }
    
    // Get bot next move (based on combinations)
    func getBotNextMove() -> Coordinate {
        if !botMoveCombinations.isEmpty {
            let lastCombIndex = botMoveCombinations.count - 1
            let lastCombination = botMoveCombinations[lastCombIndex]
            let lastPosIndex = lastCombination.count - 1
            let lastPos = lastCombination[lastPosIndex]
            botMoveCombinations[lastCombIndex].removeLast()
            if botMoveCombinations[lastCombIndex].isEmpty {
                botMoveCombinations.removeLast()
            }
//            print("line 362, botMoveCombinations \(botMoveCombinations)")
//            print("line 363, getBotNextMoveCombination() \(lastPos)")
            return lastPos
        }
        let lastPos = getNextStep()
//        print("line 360, getBotNextMoveCombination() \(lastPos)")
        return lastPos
    }
    
    // check if a location is valid for bot
    func isBotValidMove(x: Int, y: Int) -> Bool {
//        print("line 368, x=\(x), y=\(y)")
        return ((zoneStates[x][y] == .clear) || (zoneStates[x][y] == .myCompartment))
    }
    
    /*
     Reset Bot's last hit ships
     fill with (x: -1, y: -1)
     */
    func resetBotLastHitShips() {
        for (i, x) in fleet2.ships.enumerated() {
            botLastHitShips[i].coordinates.removeAll()
            for _ in x.coordinates() {
                botLastHitShips[i].coordinates.append(Coordinate(x: -1, y: -1))
            }
        }
        
        botLastHitShipName = ""
    }
    
    /*
     Update Bot last hit ships
     to keep track of hit coordinates
     */
    func updateBotLastHitShips(shipName: String, location: Coordinate) {
        if let i = botLastHitShips.firstIndex(where: {$0.name == shipName}) {
            if let j = botLastHitShips[i].coordinates.firstIndex(where: {$0.x == -1}) {
                botLastHitShips[i].coordinates[j] = location
            } else {
                print("Cannot find empty coordinate at \(shipName) in botLastHitShips")
            }
        } else {
            print("Cannot find \(shipName) in botLastHitShips")
        }
        
        botLastHitShipName = shipName
    }
    
    /*
     Get combinations (needs optimizing)
     */
    func getCombinations(location: Coordinate, numOfCompartments: Int) -> [[Coordinate]] {
        var comb = [[Coordinate]]()
        let lastX = location.x
        let lastY = location.y
        
        if numOfCompartments == 3 {
            if (lastX + 1 < Game.numCols && isBotValidMove(x: lastX + 1, y: lastY)) {
                comb.append([Coordinate(x: lastX + 1, y: lastY), Coordinate(x: lastX + 2, y: lastY)])
//                print("432")
            }
            if (lastX - 2 >= 0 && isBotValidMove(x: lastX - 1, y: lastY)) {
                comb.append([Coordinate(x: lastX - 1, y: lastY), Coordinate(x: lastX - 2, y: lastY)])
//                print("436")
            }
            
            if (lastY + 1 < Game.numRows && isBotValidMove(x: lastX, y: lastY + 1)) {
                comb.append([Coordinate(x: lastX, y: lastY + 1), Coordinate(x: lastX, y: lastY + 2)])
//                print("441")
            }
            if (lastY - 2 >= 0 && isBotValidMove(x: lastX, y: lastY - 1)) {
                comb.append([Coordinate(x: lastX, y: lastY - 1), Coordinate(x: lastX, y: lastY - 2)])
//                print("445")
            }

            // case in the middle
            /**
             1
             x
             1
             */
            if (lastX + 1 < Game.numCols && lastX > 0 && isBotValidMove(x: lastX + 1, y: lastY)) {
                comb.append([Coordinate(x: lastX - 1, y: lastY), Coordinate(x: lastX + 1, y: lastY)])
//                print("456")
            }
            
            if (lastY + 1 < Game.numRows && lastY > 0 && isBotValidMove(x: lastX, y: lastY + 1)) {
                comb.append([Coordinate(x: lastX, y: lastY - 1), Coordinate(x: lastX, y: lastY + 1)])
//                print("461")
            }
            return comb
        }

        if (lastX + 1 < Game.numCols && isBotValidMove(x: lastX + 1, y: lastY)) {
            comb.append([Coordinate(x: lastX + 1, y: lastY)])
//            print("468")
        }
        if (lastX > 0 && isBotValidMove(x: lastX - 1, y: lastY)) {
            comb.append([Coordinate(x: lastX - 1, y: lastY)])
//            print("471")
        }
        
        if (lastY + 1 < Game.numRows && isBotValidMove(x: lastX, y: lastY + 1)) {
            comb.append([Coordinate(x: lastX, y: lastY + 1)])
//            print("476")
        }
        if (lastY > 0 && isBotValidMove(x: lastX, y: lastY - 1)) {
            comb.append([Coordinate(x: lastX, y: lastY - 1)])
//            print("479")
        }
        
        return comb
    }
    
    /*
     Get number of compartments based on ship name
     */
    func getNumOfCompartments(shipName: String) -> Int {
        let ships = fleet2.ships
        if let index = ships.firstIndex(where: {$0.name == shipName}) {
            return ships[index].length
        } else {
            print("Cannot get number of compartments of \(shipName)")
            return -1
        }
    }
    
    /*
     create a two dimensional array of OceanZoneStates all set to .clear
     */
    private func defaultZoneStates() -> [[OceanZoneState]] {
        var states = [[OceanZoneState]]()
        for x in 0..<Game.numCols {
            states.append([])
            for _ in 0..<Game.numRows {
                states[x].append(.clear)
            }
        }
        
        return states
    }
    
    /*
     parse 2D array of Int to Zone States
     */
    private func parseZoneStates(stateArr: [[Int]]) -> [[OceanZoneState]] {     
        var states = [[OceanZoneState]]()
        for (i, x) in stateArr.enumerated() {
            states.append([])
            for y in x {
                states[i].append(OceanZoneState(rawValue: y)!)
            }
        }
        
//        print(states)
        return states
    }
}
