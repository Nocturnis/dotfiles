'use babel'
/* eslint-env jasmine */

describe('builder-go', () => {
  let mainModule = null

  beforeEach(() => {
    waitsForPromise(() => {
      return atom.packages.activatePackage('go-config').then(() => {
        return atom.packages.activatePackage('builder-go')
      }).then((pack) => {
        mainModule = pack.mainModule
      })
    })

    waitsFor(() => {
      return mainModule.getGoconfig() !== false
    })
  })

  describe('when the builder-go package is activated', () => {
    it('activates successfully', () => {
      expect(mainModule).toBeDefined()
      expect(mainModule).toBeTruthy()
      expect(mainModule.getBuilder).toBeDefined()
      expect(mainModule.getGoconfig).toBeDefined()
      expect(mainModule.consumeGoconfig).toBeDefined()
      expect(mainModule.getGoconfig()).toBeTruthy()
      expect(mainModule.getBuilder()).toBeTruthy()
    })
  })
})
