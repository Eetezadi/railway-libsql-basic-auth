package main

import (
	"crypto/ed25519"
	"encoding/base64"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

func main() {
	// Generate a fresh Ed25519 pair
	pub, priv, err := ed25519.GenerateKey(nil)
	if err != nil {
		panic(err)
	}

	// Create a 10-year token
	// This token is signed by the private key we just generated
	token := jwt.NewWithClaims(jwt.SigningMethodEdDSA, jwt.MapClaims{
		"sub": "admin",
		"exp": time.Now().AddDate(10, 0, 0).Unix(),
	})

	signedToken, _ := token.SignedString(priv)

	// Output ONLY the public pieces
	fmt.Println("---------------------------------------------------------")
	fmt.Println("🔒 DATABASE SETUP (Copy to Railway Variable)")
	fmt.Println("Variable Name: SQLD_AUTH_JWT_KEY")
	fmt.Println("Value:", base64.RawURLEncoding.EncodeToString(pub))
	fmt.Println("---------------------------------------------------------")
	fmt.Println("🎟️ APP CREDENTIAL (Copy to Drizzle .env)")
	fmt.Println("DATABASE_AUTH_TOKEN=" + signedToken)
	fmt.Println("---------------------------------------------------------")
	fmt.Println("⚠️ Note: The Private Key was destroyed after signing.")
	fmt.Println("To rotate keys, simply delete the Railway variable and redeploy.")
}