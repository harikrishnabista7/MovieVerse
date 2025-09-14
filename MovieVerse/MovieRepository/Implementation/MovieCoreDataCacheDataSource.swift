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

    func getMovies() async throws -> [Movie] {
        let fetchRequest = DBMovie.fetchRequest()
        fetchRequest.fetchLimit = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]
        let dMovies = try await controller.viewContext.fetch(fetchRequest)
        return dMovies.map { $0.toMovie() }
    }

    func searchMovies(query: String) async throws -> [Movie] {
        let fetchRequest = DBMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
        fetchRequest.fetchLimit = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]

        let dMovies = try await controller.viewContext.fetch(fetchRequest)
        return dMovies.map { $0.toMovie() }
    }

    func getMovieDetail(id: Int32) async throws -> MovieDetail {
        let fetchRequest = DBMovieDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let detail = try await controller.viewContext.fetch(fetchRequest).first
            if let detail {
                return detail.toMovieDetail()
            }

            throw AppError.notFound
        } catch {
            throw AppError.notFound
        }
    }

    func getMoviesPage(searchQuery: String?, after lastMovieId: Int32?) async throws -> [Movie] {
        let fetchRequest = DBMovie.fetchRequest()

        var predicates: [NSPredicate] = []

        if let searchQuery {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", searchQuery))
        }

        if let lastMovieId, let lastMovie = try await getMovie(id: lastMovieId) {
            predicates.append(NSPredicate(format: "popularity < %f", lastMovie.popularity))
        }

        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.fetchLimit = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]
        let dMovies = try await controller.viewContext.fetch(fetchRequest)
        return dMovies.map { $0.toMovie() }
    }

    func addMovieToFavorites(_ movieId: Int32) async throws {
        let context = getSavingContext()

        try await context.perform {
            let fetRequest = movieFetchRequest(for: movieId)
            let movie = try context.fetch(fetRequest).first
            movie?.isFavorite = true
            try context.save()
        }
    }

    func removeMovieFromFavorites(_ movieId: Int32) async throws {
        let context = getSavingContext()

        try await context.perform {
            let fetRequest = movieFetchRequest(for: movieId)
            let movie = try context.fetch(fetRequest).first
            movie?.isFavorite = false
            try context.save()
        }
    }

    func isFavoriteMovie(_ movieId: Int32) async throws -> Bool {
        let movie = try await getMovie(id: movieId)
        return movie?.isFavorite ?? false
    }

    func saveMovies(_ movies: [Movie]) async throws {
        let context = getSavingContext()

        try await context.perform {
            try movies.forEach {
                let fetRequest = movieFetchRequest(for: $0.id)
                let movie = try context.fetch(fetRequest).first
                let isFavorite = movie?.isFavorite ?? false

                let dbMovie = movie ?? DBMovie(context: context)
                dbMovie.initWith($0)
                dbMovie.isFavorite = isFavorite
            }
            try context.save()
        }
    }

    func saveMovieDetail(_ detail: MovieDetail) async throws {
        let context = getSavingContext()

        try await context.perform {
            let dbDetail = DBMovieDetail(context: context)
            dbDetail.initWith(detail)
            try context.save()
        }
    }

    private func getMovie(id: Int32) async throws -> DBMovie? {
        let fetchRequest: NSFetchRequest<DBMovie> = DBMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        return try await controller.viewContext.fetch(fetchRequest).first
    }

    private func movieFetchRequest(for id: Int32) -> NSFetchRequest<DBMovie> {
        let fetchRequest: NSFetchRequest<DBMovie> = DBMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        return fetchRequest
    }

    private func getSavingContext() -> NSManagedObjectContext {
        let backgroundContext = controller.container.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return backgroundContext
    }
}

// MARK: - DBMovie

fileprivate extension DBMovie {
    func initWith(_ movie: Movie) {
        id = movie.id
        title = movie.title
        releaseDate = movie.releaseDate
        posterPath = movie.posterPath
        popularity = movie.popularity
        isFavorite = false
    }

    func toMovie() -> Movie {
        .init(title: title ?? "",
              id: id,
              releaseDate: releaseDate ?? "",
              posterPath: posterPath ?? "",
              popularity: popularity)
    }
}

// MARK: - DBMovieDetail

fileprivate extension DBMovieDetail {
    func initWith(_ movieDetail: MovieDetail) {
        id = Int32(movieDetail.id)
        title = movieDetail.title
        releaseDate = movieDetail.releaseDate
        posterPath = movieDetail.posterPath
        overview = movieDetail.overview
        backdropPath = movieDetail.backdropPath
        rating = movieDetail.rating
        runtime = Int16(movieDetail.runtime)
    }

    func toMovieDetail() -> MovieDetail {
        var genres: [Genre] = []
        if let dbGenres = self.genres as? Set<DBGenre> {
            genres = Array(dbGenres).map { .init(id: $0.id, name: $0.name ?? "") }
        }

        return MovieDetail(title: title ?? "",
                           id: id,
                           releaseDate: releaseDate ?? "",
                           posterPath: posterPath ?? "",
                           backdropPath: backdropPath ?? "",
                           rating: rating,
                           runtime: runtime,
                           overview: overview ?? "",
                           genres: genres)
    }
}

// MARK: - DBMovieDetail

fileprivate extension DBGenre {
    func initWith(_ genre: Genre) {
        id = genre.id
        name = genre.name
    }
}
