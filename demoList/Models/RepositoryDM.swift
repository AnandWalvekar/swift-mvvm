struct RepositoryDM {
    let name: String
    let language: String?
    let cloneUrl: String
    
    init(repository: Repository) {
        self.name = repository.name
        self.cloneUrl = repository.cloneUrl
        self.language = repository.language
    }
}

