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
        fetchRequest.fetchLimit = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]
        let dMovies = try controller.viewContext.fetch(fetchRequest)
        return dMovies.map { $0.toMovie() }
    }

    @MainActor
    func searchMovies(query: String) async throws -> [Movie] {
        let fetchRequest = DBMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
        fetchRequest.fetchLimit = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false)]

        let dMovies = try controller.viewContext.fetch(fetchRequest)
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

    func saveMovies(_ movies: [Movie]) async throws {
        let context = getSavingContext()

        try await context.perform {
            movies.forEach {
                let dbMovie = DBMovie(context: context)
                dbMovie.initWith($0)
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

    private func getSavingContext() -> NSManagedObjectContext {
        let backgroundContext = controller.container.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return backgroundContext
    }
}

// MARK: - DBMovie

extension DBMovie {
    func initWith(_ movie: Movie) {
        id = movie.id
        title = movie.title
        releaseDate = movie.releaseDate
        posterPath = movie.posterPath
        popularity = movie.popularity
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

extension DBMovieDetail {
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

extension DBGenre {
    func initWith(_ genre: Genre) {
        id = genre.id
        name = genre.name
    }
}
