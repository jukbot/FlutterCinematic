import 'package:flutter/material.dart';
import 'package:movies_flutter/model/episode.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/model/tvseason.dart';
import 'package:movies_flutter/util/api_client.dart';
import 'package:movies_flutter/util/styles.dart';
import 'package:movies_flutter/widgets/season_detail/episode_card.dart';


class SeasonDetailScreen extends StatelessWidget {

  final MediaItem show;
  final TvSeason season;

  final ApiClient _apiClient = ApiClient.get();

  SeasonDetailScreen(this.show, this.season);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: primary,
        body: new CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(),
            _buildEpisodesList()
          ],
        )
    );
  }

  Widget _buildAppBar() {
    return new SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: new FlexibleSpaceBar(
        background: new Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget>[
            new Column(
              children: <Widget>[
                new FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    height: 230.0,
                    width: double.infinity,
                    placeholder: "assets/placeholder.jpg",
                    image: show.getBackDropUrl()),
                new Expanded(
                  child: new Container(
                    child: new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Text(show.title, style: captionStyle,),
                          new Container(height: 4.0,),
                          new Text(
                              "Season ${season.seasonNumber}",
                              style: whiteBody.copyWith(fontSize: 18.0)),
                          new Container(height: 4.0,),
                          new Text(
                            "${season.getReleaseYear()} - ${season
                                .episodeCount} Episodes",
                            style: captionStyle,
                          )
                        ],
                      ),
                    ),
                    color: primaryDark,
                  ),
                )
              ],
            ),
            new Padding(
              padding: const EdgeInsets.all(24.0),
              child: new Hero(
                tag: 'Season-Hero-${season.id}',
                child: new FadeInImage.assetNetwork(
                    width: 100.0,
                    placeholder: "assets/placeholder.jpg",
                    image: season.getPosterUrl()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodesList() {
    return new SliverList(
        delegate: new SliverChildListDelegate(
            <Widget>[
              new FutureBuilder(
                  future: _apiClient.fetchEpisodes(
                      show.id, season.seasonNumber),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Episode>> snapshot) =>
                  snapshot.connectionState != ConnectionState.done
                      ? new Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: new Center(child: new CircularProgressIndicator(),),
                      )
                      : new Column(
                    children: snapshot.data.map((
                        Episode episode) => new EpisodeCard(episode)).toList(),
                  )
              )
            ]
        )
    );
  }

}
