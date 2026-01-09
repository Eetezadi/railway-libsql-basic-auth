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

	fmt.Print(`
################################################################################
###                                                                          ###
###  🔐 libSQL CREDENTIALS - COPY THESE VALUES                              ###
###                                                                          ###
################################################################################

→ RAILWAY VARIABLE (paste in Railway Service Variables):
  SQLD_AUTH_JWT_KEY=` + base64.RawURLEncoding.EncodeToString(pub) + `

→ CLIENT ENV (paste in your .env file):
  DATABASE_AUTH_TOKEN=` + signedToken + `

ℹ️  Private key was destroyed after signing. To rotate, delete the Railway
   variable SQLD_AUTH_JWT_KEY and redeploy.

################################################################################
`)
}