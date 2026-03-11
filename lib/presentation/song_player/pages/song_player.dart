import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/domain/entities/song/song.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity songEntity;
  const SongPlayerPage({super.key, required this.songEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: const Text('Now Playing', style: TextStyle(fontSize: 18)),
        action: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert_rounded),
        ),
      ),
      body: BlocProvider(
        create:
            (_) =>
                SongPlayerCubit()..loadSong(
                  '${AppUrls.songFirestorage}${Uri.encodeComponent('${songEntity.artist} - ${songEntity.title}.mp3')}${AppUrls.mediaAlt}',
                ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              _songCover(context),
              const SizedBox(height: 20),
              _songDetail(),
              const SizedBox(height: 30),
              _songPlayer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _songCover(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            '${AppUrls.coverFirestorage}${Uri.encodeComponent('${songEntity.artist} - ${songEntity.title}.jpg')}${AppUrls.mediaAlt}',
          ),
        ),
      ),
    );
  }

  Widget _songDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              songEntity.title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            SizedBox(height: 5),
            Text(
              songEntity.artist,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite_outline_outlined,
            size: 35,
            color: AppColors.darkGrey,
          ),
        ),
      ],
    );
  }

  Widget _songPlayer() {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoading) {
          return const CircularProgressIndicator();
        }

        if (state is SongPlayerLoaded) {
          final cubit = context.read<SongPlayerCubit>();
          final position = cubit.songPosition.inSeconds.toDouble();
          final duration = cubit.songDuration.inSeconds.toDouble();

          return Column(
            children: [
              Slider(
                value: position > duration ? duration : position,
                min: 0.0,
                max: duration > 0 ? duration : 1.0,
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    formatDuration(cubit.songPosition),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    formatDuration(cubit.songDuration),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_previous),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon:
                        cubit.audioPlayer.playing
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.skip_next),
                  ),
                ],
              ),
            ],
          );
        }

        return Container();
      },
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
