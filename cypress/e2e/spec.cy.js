describe('Bootstrap Resume Website Navigation', () => {
  beforeEach(() => {
    cy.visit('http://localhost:3000')
  })

  it('should display all navigation links', () => {
    cy.get('.navbar-nav .nav-link').should('have.length', 6)
  })

  it('should navigate to the About section when About link is clicked', () => {
    cy.get('a.nav-link[href="#about"]').click()
    cy.url().should('include', '#about')
    cy.get('#about').should('be.visible')
  })

  it('should navigate to the Experience section when Experience link is clicked', () => {
    cy.get('a.nav-link[href="#experience"]').click()
    cy.url().should('include', '#experience')
    cy.get('#experience').should('be.visible')
  })

  it('should navigate to the Education section when Education link is clicked', () => {
    cy.get('a.nav-link[href="#education"]').click()
    cy.url().should('include', '#education')
    cy.get('#education').should('be.visible')
  })

  it('should navigate to the Skills section when Skills link is clicked', () => {
    cy.get('a.nav-link[href="#skills"]').click()
    cy.url().should('include', '#skills')
    cy.get('#skills').should('be.visible')
  })

  it('should navigate to the Interests section when Interests link is clicked', () => {
    cy.get('a.nav-link[href="#interests"]').click()
    cy.url().should('include', '#interests')
    cy.get('#interests').should('be.visible')
  })

  it('should navigate to the Awards section when Awards link is clicked', () => {
    cy.get('a.nav-link[href="#awards"]').click()
    cy.url().should('include', '#awards')
    cy.get('#awards').should('be.visible')
  })
})