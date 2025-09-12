//
//  CoreDataCacheMovieDataSource.swift
//  MovieVerse
//
//  Created by hari krishna on 10/09/2025.
//
import CoreData

struct MovieCoreDataCacheDataSource: MovieCacheDataSource {
    let controller: CoreDataController

    init(controller: CoreDataController = .shared) {
        self.controller = controller
    }

    @MainActor
    func getMovies() async throws -> [Movie] {
        let fetchRequest = DBMovie.fetchRequest()
        let dMovies = try controller.viewContext.fetch(fetchRequest)
        return dMovies.map { $0.toMovie() }
    }

    @MainActor
    func searchMovies(query: String) async throws -> [Movie] {
        let fetchRequest = DBMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
        let dMovies = try controller.viewContext.fetch(fetchRequest)
        return dMovies.map { $0.toMovie() }
    }

    func getMovieDetail(id: Int) async throws -> MovieDetail {
        .init(title: "", id: 0)
    }

    func saveMovies(_ movies: [Movie]) async throws {
        let backgroundContext = controller.container.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

        try await backgroundContext.perform {
            movies.forEach {
                let dbMovie = DBMovie(context: backgroundContext)
                dbMovie.initWith($0)
            }
            try backgroundContext.save()
        }
    }

    func saveMovieDetail(_ detail: MovieDetail) async throws {
    }
}

extension DBMovie {
    func initWith(_ movie: Movie) {
        id = Int32(movie.id)
        title = movie.title
        releaseData = movie.releaseDate
        posterPath = movie.posterPath
        overview = movie.overview
    }

    func toMovie() -> Movie {
        .init(title: title ?? "",
              id: Int(id),
              releaseDate: releaseData ?? "",
              posterPath: posterPath ?? "",
              overview: overview ?? "")
    }
}
