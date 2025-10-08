import jenkins.model.*
import hudson.security.*
import jenkins.security.s2m.AdminWhitelistRule

def instance = Jenkins.getInstance()

// Create admin user
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin123")
instance.setSecurityRealm(hudsonRealm)

// Set authorization strategy to allow admin full control
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

// Disable JNLP agent to master security for now
instance.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)

// Save configuration
instance.save()

println("Admin user created: admin / admin123")

