package com.wanderlab.vietnambeyondthehorizon.osm_connection

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.HttpUrl.Companion.toHttpUrl
import okhttp3.OkHttpClient
import okhttp3.Request
import org.json.JSONArray

private val client = OkHttpClient()
interface OSMConnection {
    suspend fun searchOpenStreetMap(query: String): List<Place>;
}
internal class IOSMConnection: OSMConnection {
    override suspend fun searchOpenStreetMap(query: String): List<Place> =
        withContext(Dispatchers.IO) {
            val url = "https://nominatim.openstreetmap.org/search"
                .toHttpUrl()
                .newBuilder()
                .addQueryParameter("q", query)
                .addQueryParameter("format", "json")
                .addQueryParameter("limit", "10")
                .build()

            val request = Request.Builder()
                .url(url)
                .header(
                    "User-Agent",
                    "osm connection"
                )
                .build()

            var result = emptyList<Place>();
            try {
                client.newCall(request).execute().use { response ->
                    if (!response.isSuccessful) {
                        println(response.body?.string())
                        throw Exception("HTTP ${response.code}")
                    }

                    val body = response.body?.string()
                        ?: return@withContext emptyList()

                    val json = JSONArray(body)

                    result = buildList {
                        for (i in 0 until json.length()) {
                            val item = json.getJSONObject(i)

                            add(
                                Place(
                                    name = item.optString("name"),
                                    displayName = item.optString("display_name"),
                                    latitude = item.getDouble("lat"),
                                    longitude = item.getDouble("lon")
                                )
                            )
                        }
                    }
                }
            }
            catch (e: Exception) { }
            result;
        }
}
val osm_connection: OSMConnection = IOSMConnection()