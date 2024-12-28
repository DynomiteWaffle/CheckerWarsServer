package main

import (
	"flag"
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	// gin.SetMode(gin.ReleaseMode) // sets release mode
	// TODO
	// cli settings - port - map - admin otp
	port := flag.String("port", "8080", "Sets server port number")
	// mapLocation := flag.String("map", "", "Runs server on map") // TODO
	// adminOtp := flag.String("adminOTP", "", "Sets admin otp") // TODO
	// admin := flag.Bool("adminOTP", false, "Enables admin commands") // TODO
	flag.Parse()

	router := gin.Default()
	router.GET("/", home) // returns game state and current turn
	// router.GET("/Join") // returns uuid
	// router.GET("/Map") // returns state of the map
	// router.GET("/Map/Players") // returns link between player number and color
	// router.GET("/Map/Info") // returns info like width, height, author
	// router.POST("/Move) // user requests a piece to move
	// router.GET("/Quit") // user requests forfet
	// router.POST("/User") // user requests info like, turns till your turn
	// Admin Stuff
	// router.Get("/Admin") // retruns admin commands
	// router.POST("/Admin/Command") // runs a admin command

	router.RunTLS(":"+*port, "server.cert", "server.key")
}
func home(c *gin.Context) {

	c.String(http.StatusOK, "wasd")
}
