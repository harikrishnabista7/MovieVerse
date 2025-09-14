# Development Decisions & Challenges

## Getting Started with TMDb SDK

Since The Movie Database (TMDb) SDK was new to me, and I had spent the last year focused on building a video editor, the initial phase of this project felt a bit unstructured. At first, I found myself frequently switching between SDK documentation and Xcode, which slowed progress.

**Solution:**  
I first spent focused time understanding the essential parts of the SDK — authentication, discover, and movie detail endpoints. Once I had a clear grasp of these, I designed the app’s architecture and implemented it one small feature at a time. This iterative approach kept development organized and allowed me to refine the code structure as the project evolved.

---

## Pagination

The TMDb API supports server-side pagination, so I simply tracked the current page and passed the next page number when loading more results.

However, implementing pagination for locally cached data was trickier, since Core Data does not have a concept of pages.

**Solution:**

- Used a **fetch limit of 20** to mimic a page size.
- Tracked the `lastMovieId` in the current list.
- Queried Core Data for movies with **lower popularity** than the last item (since results are sorted by popularity descending).

This kept the behavior consistent between online and offline modes.

---

## Favorites

Initially, I considered using TMDb’s session-based list feature to sync favorites. I even started implementing it, but after revisiting the requirements, I saw there was no need for account-based persistence.

**Solution:**  
I switched to a **local favorites list** using Core Data. This was faster to implement, worked offline, and met the requirements without introducing session management complexity.

---

## Error Handling & Offline Mode

Rather than showing intrusive alerts for network errors, I chose to display **inline error messages** within the list or details screen. This provides a smoother user experience.

For connectivity handling:

- I observed network status changes.
- If data was missing (e.g., no search results or details), the app would **silently retry fetching** when the connection became available again.

This approach reduced user frustration and made the app feel more reliable.
