import 'package:injectable/injectable.dart';
import 'package:panna_app/features/articles/domain/entities/article_detail_entity.dart';
import 'package:panna_app/features/articles/domain/entities/article_entity.dart';

@injectable
class ArticlesLocalDataSource {
  // Hard-coded dummy articles (as provided in your UI example).
  final Map<String, String> topStory = {
    'imageUrl': 'assets/images/haaland.png',
    'author': 'Panna Team',
    'date': 'October 19th, 2024',
    'title': 'Welcome Beta Testers!',
    'content': '''
### Welcome to Panna!
We are thrilled to introduce you to our latest app, designed to change your sports experience based on the "Last Man Standing" game. At panna, we believe in combining the excitement of sports with interactive features that keep you engaged and connected.

### Key Features:

**Live Results and Standings:**
Stay updated in real-time with live scores, comprehensive standings, and in-depth statistics. Whether you're tracking your favourite team or analysing player performances, our Live Results feature ensures you never miss a beat.

**Sports Betting:**
Experience the adrenaline rush of sports betting with our secure and user-friendly platform. Place bets on various sports events, manage your wagers, and celebrate your wins, all within the app.

**Chat Feature:**
Connect with fellow sports enthusiasts through our integrated chat feature. Share your predictions, discuss game strategies, or simply engage in friendly banter as you cheer for your teams.

At panna, our mission is to create a holistic sports platform that caters to your every need, whether you're a casual fan or a die-hard supporter. Join us on this exciting journey and elevate your sports engagement to new heights!

**Happy Gaming!**

The Panna Team
'''
  };

  final Map<String, String> article3 = {
    'imageUrl': 'assets/images/homegrown.png',
    'author': 'Nick Saunders',
    'date': 'January 29th, 2024',
    'title':
        'Why is more money spent on transfers rather than bolstering academies?',
    'content': '''
Last week, my flatmate Felix and I were discussing the rumours of the January transfer window. During our conversation, he asked:

"Why do Premier League teams spend so much more money on external transfers than on their academy?"

At first, it seemed obvious—big transfers bring proven players who can deliver immediate success. But after thinking about it more, there’s a strong case for clubs to stop splashing cash on expensive signings and instead invest more into their academies.

**The Disparity Between Transfer Spending and Academy Investment**

Academy budgets vs. transfer fees:
On average, clubs with a Category One academy (22 clubs) spend £3.5 million per year on their academies. Compared to modern-day transfer fees and wages, this is a tiny amount.

For example, Raheem Sterling earns £8.5 million per year—more than double what an entire academy costs. Similarly, Manchester United spent £85.6 million on Antony, a player who has only produced five goals and three assists in 2.5 years of Premier League football.

Instead of gambling on underperforming transfers, clubs could invest in their youth systems, scout top talent early, and develop committed academy players who understand the club’s culture and style.

**The Importance of Academies in Building Great Teams**

Some might argue that signing experienced players is better than relying on youth prospects. However, history proves otherwise.

Consider legendary teams like:
- Pep Guardiola’s Barcelona
- Ajax with Cruyff & co.
- Bayern Munich with Beckenbauer
- Manchester United’s Class of ’92
- Each of these teams was built on strong academy foundations. Developing homegrown talent creates squads that play together for years, resulting in unmatched chemistry and long-term success.

**Why Won’t This Happen Again?**

Unfortunately, modern football is too money-driven for this model to work again.

Clubs view academy players as profit-making assets rather than long-term investments. Take Cole Palmer, Scott McTominay, and Conor Gallagher—all talented homegrown players, yet seen as prime candidates to be sold for financial gain.

Academy graduates officially cost clubs £0, so selling them generates pure profit, which helps balance FFP regulations and fund new signings. As a result, clubs focus on developing players to sell them rather than keeping them to build a legacy.

**The Death of the One-Club Player**

This financial strategy has all but eliminated the one-club player—someone like John Terry, who remained at Chelsea for his entire career.

Fans once thought Mason Mount would follow the same path, but now he plays for Manchester United (when he’s not injured).

While full academy-built teams seem unlikely to return, Chelsea’s recent transfer strategy offers a similar approach. By signing young players on long contracts, they are building a squad with the potential to develop long-term chemistry and success.

**Conclusion: Will Clubs Ever Prioritise Academies Again?**

So, in answer to Felix’s question—modern football is too business-oriented to justify increased academy investment. Clubs will continue spending outrageous transfer fees rather than nurturing their own talent.

Should they allocate more funds to academies? Absolutely. Will they? Probably not.

But perhaps, through new strategies like Chelsea’s, we might see a modern version of academy-built success.
'''
  };

  final Map<String, String> article2 = {
    'imageUrl': 'assets/images/bournemouth_alfie_franklin.png',
    'author': 'Alfie Franklin',
    'date': 'January 29th, 2025',
    'title':
        'I’m unashamedly in love with Bournemouth, and you can’t do anything about it.',
    'content': '''
It was a typically disappointing Saturday in Edinburgh. I’d woken up with a stinging hangover, a tee-shirt drenched in sweat, and the smell of kebab lingering ominously in my room. Ouch.

The day was passed staring hopefully at my laptop, as if by some miracle, my essay might appear on the screen. I then trudged to a friend’s house, limping meekly, to watch a Saka-less Arsenal attempt to beat Bournemouth. It went as you’d expect—a Saliba red card, another flaccid Sterling showing, and a 2-0 win for the Cherries.

Yet—like the little sadist I am—I quite enjoyed it. I’ve always had a soft spot for Bournemouth, not to the same depth or complexity as my infatuation for Sean Dyche’s Burnley, but I have always nurtured a little crush for that punchy little team. Watching them smack Manchester United at Old Trafford (again) and draw with Chelsea at the Bridge has done nothing to quell my dirty little secret.

Over the past week, they have beaten Nottingham Forest and Newcastle by an aggregate of 9-1. Since the season’s first five games, they have picked up more points than any team not called Liverpool or Arsenal. They have the league’s youngest centre-back pairing, and both play with black gloves and short socks—what’s not to love?

Since the halcyon days of Dyche’s Burnley (still my one true love), I haven’t felt a connection to an inane team with whom I have no true connection. But Bournemouth are different. I challenge anyone to watch Dean Huijsen’s ‘Chill Guy’ celebration at Old Trafford and call me false.

They are stocked with players who—one day—you will chuck at random into conversation with the vain hope of stirring up some kind of reaction. I can see myself in twenty years getting all misty-eyed as I put my arm around some poor nephew and talk at them about Milos Kerkez’s goal away at Newcastle, or just how underrated Ryan Christie was. I would probably collapse into a happy reverie, mumbling something about Justin Kluivert…

In short, I would watch Bournemouth. They are going somewhere. How Andone Iraola is still there is beyond me—having said that, I am delighted that he dodged the United bullet. With the Premier League set to receive a fifth Champions League spot, you’d be a fool to bet against them to secure it.
'''
  };

  final Map<String, String> article1 = {
    'imageUrl': 'assets/images/referee_photo.png',
    'author': 'Atticus Evans-Lombe',
    'date': 'January 31st, 2025',
    'title': 'Referee Abuse and the Hysteria of Modern Football',
    'content': '''
Last weekend, the Arsenal defender Myles Lewis-Skelly committed a foul and the football world erupted. Felling Wolves player Matt Doherty with what seemed to be a textbook professional foul, Lewis-Skelly was surprisingly shown a straight red card by referee Michael Oliver. Outrage spread like wildfire across social media, all the way up to the heady heights of the Match of the Day studio, and condemnation was universal: for what it’s worth, this humble Arsenal fan also believes it was a dreadful decision. Predictably enough, the discourse didn’t end there, and the past week has been awash with allegations of corruption and foul play – police were even dispatched to Oliver’s home due to death threats received on social media.

As ever, the football world managed to remain calm and level-headed when a moment of controversy arrived. I must confess that I thrill at the relentless drama train the Premier League has become and will happily lap up Roy Keane’s ruthless assassination of some poor teenager’s defending every weekend. Yet when it comes to referees a line has been crossed and it is clear that people need to take a step back.

Referee abuse is no novelty. It is a naturally demeaning position, the representative of the law who ruins the fun for everyone else, and contempt for them pervades every level of the game. At grassroots level, nearly 1500 cases of abuse were reported in the 2022-23 season including, remarkably, 72 cases of “actual or alleged assault”. While it seems unlikely that many grow up dreaming of donning the referee’s black and white stripes, people might just be taking their disdain for the official a little too seriously.

This has now reached a tipping point thanks to the culture we’ve created around the game. Refereeing standards are undoubtedly higher than in previous generations yet, especially with the increased scrutiny engendered by VAR, every small mistake is greeted with vicious accusations and howls of disbelief. In fairness, most ‘professional’ pundits have largely steered clear of this, condemning the abuse Oliver has received. Yet some couldn’t resist twisting the knife: Micah Richards proclaimed it “the worst decision I’ve ever seen in Premier League history.” This from a man whose other visionary insights include stating “I love Brest.”

The issue lies not here but with the status we bestow on figures from social media within such conversations. Unsurprisingly most of the abuse can be traced to Youtube or Twitter, sites where anyone can join the melee without fear of condemnation, and often with the comfort of anonymity. This has been the case for a long time now, but recent years have seen a blurring of the barrier between ‘serious’ and casual footballing debate. Youtubers like Mark Goldbridge and Arsenal Fan TV have garnered millions of followers through entertaining and provocative debate from the casual fan’s perspective. Again, there is no problem with this in and of itself, and I would agree that it seems hyperbolic to pay so much attention to the ramblings of random people on Twitter. Unfortunately, however, we live in a world where figures such as Goldbridge are invited onto Sky Sports to discuss football with ex-professionals like Richards, thus giving them credentials as authoritative voices within the sport.

This is why these figures crying wolf and insisting that corruption is afoot is so dangerous. Conspiring with cheating referees is not unprecedented in football: Belgian side Anderlecht were banned from European Competition in 1997 after their club president was found to have bribed an official over one million francs; Nigerien referee Ibrahim Chaibou was banished from the game in 2019 after it was found he had fixed dozens of games. Yet to assert that the entire refereeing association, PGMOL, is a corrupt cabal influencing matches simply because of some pathological hatred for Arsenal is absurd. Referees are not above criticism and perhaps a review of the system could be encouraged: for example, the accusation that PGMOL is a ‘boys club’ where the members protect each other and are not promoted on merit deserves investigation. Nevertheless, relentless allegations of cheating are red meat to the masses on social media and lead to situations such as this, where protective custody is summoned for a referee’s family.

The utterly histrionic discourse prevalent in the game needs to stop. Have a quick peruse of social media and one can find claims that the abuse of Oliver is justified: he damaged the mental health of Arsenal fans with his decision; clubs must take drastic steps, such as threatening to forfeit games, or nothing will get done. This, remember, is not the civil rights movement, it is a game of football. A little perspective is needed or else this situation will never change, and the vicious cycle will continue. Ironically, the game will then be left in a far worse state, with the quality of referees declining as no one will want to sign themselves up for such abuse at all levels of the game. Can you blame them? Bill Shankly once said: “People think football is a matter of life and death. I assure you it’s much more serious than that.” It seems people are taking his words a little too much to heart these days.
'''
  };

  /// Converts a Map<String, String> to an ArticleDetailEntity.
  /// Missing fields are set with default values.
  ArticleDetailEntity _mapToArticleDetailEntity(
    Map<String, String> data, {
    bool isTopStory = false,
    String? id,
  }) {
    // Attempt to parse the provided date; fallback to now if parsing fails.
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(data['date']!);
    } catch (e) {
      parsedDate = DateTime.now();
    }

    final articleEntity = ArticleEntity(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: data['title'],
      authorId: data['author'], // using 'author' as the identifier
      date: parsedDate,
      content: data['content'],
      imageUrl: data['imageUrl'],
      isDraft: false,
      likes: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      topStory: isTopStory,
      shortStory: false,
      liveOpinion: false,
    );
    return ArticleDetailEntity(
      article: articleEntity,
      comments: [], // No local comments
      likes: [], // No local likes
    );
  }

  /// Returns the hard-coded list of articles.
  Future<List<ArticleDetailEntity>> getLastArticles() async {
    final articles = <ArticleDetailEntity>[];
    articles.add(
        _mapToArticleDetailEntity(topStory, isTopStory: true, id: 'topStory'));
    articles.add(_mapToArticleDetailEntity(article1, id: 'article1'));
    articles.add(_mapToArticleDetailEntity(article2, id: 'article2'));
    articles.add(_mapToArticleDetailEntity(article3, id: 'article3'));
    return Future.value(articles);
  }

  /// Caches articles locally.
  /// For the dummy data, caching is not implemented.
  Future<void> cacheArticles(List<ArticleDetailEntity> articles) async {
    // No caching needed for static local data.
    return Future.value();
  }
}
