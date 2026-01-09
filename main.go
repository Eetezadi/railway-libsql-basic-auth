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

	fmt.Println("================================================================================")
	fmt.Println("🔐 libSQL CREDENTIALS - COPY THESE VALUES")
	fmt.Println("================================================================================")
	fmt.Println("")
	fmt.Println("→ RAILWAY VARIABLE (paste in Railway Service Variables):")
	fmt.Printf("  SQLD_AUTH_JWT_KEY=%s\n", base64.RawURLEncoding.EncodeToString(pub))
	fmt.Println("")
	fmt.Println("→ CLIENT ENV (paste in your .env file):")
	fmt.Printf("  DATABASE_AUTH_TOKEN=%s\n", signedToken)
	fmt.Println("")
	fmt.Println("ℹ️  Private key was destroyed after signing. To rotate, delete the Railway")
	fmt.Println("   variable SQLD_AUTH_JWT_KEY and redeploy.")
	fmt.Println("================================================================================")
}