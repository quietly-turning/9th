// condense a give localization text into a set of unique glyphs needed for a font spritesheet
//
// TODO: read srt files directly
// TODO: CJK: raise warnings on characters that aren't monospace (e.g. latin period)

const text = `
English
Dear friends,
I have the joy of being able to tell you
that I spent a glorious hour last night
listening over the radio
to Beethoven's ninth symphony.
Last night, when the family was listening
to your wonderful rendering
of the immortal symphony,
someone suggested that I put my hand
on the receiver and see if I could get
any of the vibrations.
He unscrewed the cap
and I lightly touched the sensitive diaphragm.
What was my amazement to discover
that I could feel not only the vibrations,
but also the impassioned rhythm,
the throb, and the urge of the music.
The intertwined and intermingling vibrations
from different instruments enchanted me.
I could actually distinguish the cornets,
the role of the drums, deep tone violas,
and violins, singing in exquisite unison.
How the lovely speech of the violins
flowed and plowed over the deepest tones
of the other instruments.
When the human voice leapt up,
trilling from the surge of harmony,
I recognized them instantly as voices.
I felt the chorus grow more exultant,
more ecstatic, upcurving,
swift, and flamelike,
until my heart almost stood still.
The women's voices seemed an embodiment
of all the angelic voices
rushing in a harmonious flood
of beautiful and inspiring sound.
The great chorus throbbed against my fingers
with poignant pause and flow.
Then all the instruments and voices together
burst forth an ocean of heavenly vibration
and died away,
like winds when the atom is spent,
ending in a delicate shower of sweet notes.
Of course this was not "hearing,"
but I do know that the tones and harmonies
conveyed to me moods of great beauty and majesty.
I also sensed, or thought I did,
the tender sounds of nature
that sing into my hand:
swaying reeds,
and winds,
and the murmur of streams.
I have never been so enraptured before
by a multitude of tone vibrations.
As I listened with darkness and melody,
shadow and sound filling all the room,
I could not help remembering that the great composer
who poured forth such a flood of sweetness into the world
was deaf like myself.
I marveled at the power of his quenchless spirit
by which out of his pain
he wrought such joy for others.
And there I sat, feeling with my hand
the magnificent symphony which broke like a sea
upon the silent shores of his soul and mine.
Let me thank you warmly for all the delight
which your beautiful music has brought
to my household and to me.
With kindest regards and best wishes,
I am sincerely yours,
Helen Keller
Español
(Latin America)
Queridos amigos,
Tengo el gusto de poder decirles
que he pasado una hora gloriosa anoche
escuchando por la radio
la Novena Sinfonía de Beethoven.
Anoche, cuando la familia estaba escuchando
su maravillosa interpretación
de la sinfonía inmortal,
alguien sugirió que colocara mi mano
en el recibidor, y ver si podia sentir
algo de las vibraciones.
Esta persona desenroscó la tapa,
y toqué ligeramente el diafragma sensible.
Lo que fué mi asombro al descubrir
que podia sentir, no solamente las vibraciones,
sino que también el ritmo apasionado,
el latido, y el impulso de la musica.
Las vibraciones entrelazadas y entremezcladas
de diferentes instrumentos me maravilló.
Realmente pude dinstinguir entre las cornetas,
el rol de los tambores, las violas de tono profundo,
y los violines, cantando en un unísono exquisito.
Como el hermoso canto de los violines
floreció y aró sobre los tonos más profundos
de los demás instrumentos.
Cuando la voz humana saltó,
vibrando del surgimiento de armonía,
las reconocí instantaneamente como voces.
Sentí como el coro se volvía más exultante,
mas extático, ascendente
rapido, y flameante,
hasta que mi corazón casi se detuvo.
Las voces de las mujeres parecían la encarnación
de todas las voces angelicales
en una armoniosa avalancha
de sonidos hermosos e inspiradores.
El gran coro latía contra mis dedos
con una conmovedora pausa y flujo.
Entonces todos los instrumentos y voces juntos
irrumpieron en un océano de vibraciones celestiales
y se desvanecieron,
como vientos, cuando el átomo se agota,
terminando en una delicada lluvia de dulces notas.
Por supuesto, esto no es "escuchar",
pero si se que los tonos y armonías
me transmitían estados de ánimo de gran belleza y majestuosidad.
También sentí, o eso creí,
los tiernos sonidos de la naturaleza
que cantan en mi mano:
juncos danzantes,
vientos susurrantes,
y arroyos murmurantes.
Nunca antes me había sentido tan cautivada
por una multitud de vibraciones de tono.
Mientras escuchaba con oscuridad y melodía
sombras y sonidos llenando toda la habitación,
No pude evitar recordar que el gran compositor
que derramó tal torrente de dulzura en el mundo
era sordo, como yo.
Me maravilló el poder de su espíritu inquebrantable
con el que, a pesar de su dolor,
logró dar tanta alegría a los demás.
Y allí me senté, sintiendo con mi mano,
la magnifica sinfonía que rompía como un mar,
en las silenciosas costas de su alma y la mía.
Permítame agradecerle sinceramente todo el placer
que su hermosa música ha traído
a mi hogar y a mí.
Con mis mejores deseos y un cordial saludo,
Sinceramente suya,
Helen Keller.
Français
Chers amis,
J’ai la joie de pouvoir vous dire que,
j’ai passé hier soir une heure glorieuse
à écouter par la radio
la Neuvième Symphonie de Beethoven.
Hier soir, tandis que ma famille écoutait
votre merveilleuse interprétation
de la symphonie immortelle,
quelqu’un me suggéra de poser la main
sur le récepteur pour voir si je pouvais
en eprouver les vibrations.
On dévissa le capuchon,
et je touchai légèrement
le diaphragme sensible.
Quelle ne fut pas ma stupeur
de découvrir que je pouvais sentir,
non seulement les vibrations,
mais encore le rythme passionné,
le battement et l’élan de la musique!
Les vibrations entremêlées et entrelacées
des instruments diver m’enchantaient.
Je pouvais réellement distinguer les cors,
le roulement des tambours, les altos graves
et les violons chantent en harmonie exquise.
Comme le langage doux des violons
s’épanchait et se mouvait sur les sons plus profonds
des autres instruments!
Quand la voix humaine s’éleva,
jaillissante et tremblante du flot de l’harmonie,
je la reconnus aussitôt.
Je sentis le chœur commence a croître,
plus exalté, plus extatique,
s’élançant rapide et flamboyant,
jusqu’à ce que mon cœur en fût presque suspendu.
Les voix des femmes semblaient l’incarnation
de toutes les voix angéliques
en se ruant en un flot harmonieux
de sons beaux et inspirants.
Le grand chœur vibrait contre les doigts,
avec des pauses poignantes et des flux.
Puis tous les instruments et toutes les voix
éclatèrent ensemble —
un océan de vibrations célestes
et s’évanouirent
comme les vents lorsque l’atome est consumé,
en se terminant en une pluie fine de notes suaves.
Bien sûr, ce n’était point « entendre »,
mais je sais que les tons et les harmonies
me transmettaient des élans
de beauté et de majesté.
Je crus que même percevoir
les sons tendres de la nature
qui chantent dans la main:
les roseaux oscillants,
le vent,
et le murmure des ruisseaux.
Jamais encore je n’avais été aussi ravie
par une multitude de vibrations sonores.
Tandis que j’écoutais, avec l’obscurité et la mélodie,
l’ombre et le son emplissant toute la chambre,
je ne pouvais m’empêcher de songer que le grand compositeur,
qui versa ainsi tant de douceur dans le monde,
était sourd comme moi.
Je m’émerveillai de la puissance de son esprit inextinguible,
par laquelle, de sa douleur,
il tira tant de joie pour les autres.
Et là, j’étais assise, en sentant de la main
la symphonie magnifique qui se brisait comme une mer
sur les rivages silencieux de son âme et du mien.
Permettez-moi de vous remercier chaleureusement
pour tout le bonheur que votre belle musique
a apporté à ma maison et à moi-même.
Avec mes sentiments les plus affectueux
et mes vœux les plus sincères,
Helen Keller
Italiano
Cari amici,
è con grande gioia che voglio annunciarvi
che ieri notte ho trascorso un'ora di grazia
ascoltando alla radio
la Nona Sinfonia di Beethoven.
La notte scorsa, mentre la famiglia stava ascoltando
la vostra meravigliosa esecuzione
dell'immortale sinfonia,
qualcuno mi consigliò di appoggiare la mano
sul ricevitore e mi chiese se potessi percepire
qualche vibrazione.
Il coperchio venne rimosso
e io sfiorai lievemente la delicata membrana vibrante.
Quale fu la mia meraviglia nello scoprire
che potevo percepire non solo le vibrazioni,
ma anche il ritmo appassionato,
il palpito e l'impeto della musica.
Le vibrazioni intrecciate e fuse tra loro
di diversi strumenti musicali mi incantarono.
Potei chiaramente distinguere i corni,
il rullo dei tamburi, le viole dai toni profondi,
e i violini che suonavano in squisita unisonanza.
Sentii come il dolce linguaggio dei violini
fluiva e si spargeva sui toni più profondi
degli altri strumenti.
Quando la voce umana si fece udire,
squillante tra il rigoglio dell'armonia,
la riconobbi senza esitazione.
Sentii il coro farsi più esultante,
sempre più estatico, curvato verso l'alto,
rapido, fiammeggiante,
finché il mio cuore quasi si fermò.
Le voci femminili parevano incarnare
tutte le voci angeliche
che irrompevano in un'onda armoniosa
di suoni meravigliosi e ispiratori.
Il grande coro palpitava sulle mie dita
con struggente alternarsi di quiete e di moto.
Poi tutti gli strumenti e le voci insieme
eruppero in un oceano di vibrazioni celesti
per poi svanire,
come venti quando l'atomo è consunto,
culminando in una delicata pioggia di dolci note.
Certamente, ciò non era "udire"
ma so che i toni e le armonie
mi trasmisero sensazioni di grande bellezza e maestà.
Mi parve anche di percepire, o così credetti,
i fievoli suoni della natura
che cantavano nella mia mano:
i giunchi che ondeggiano,
e i venti,
e il mormorio dei ruscelli.
Mai prima d'ora ero stata così rapita
da una moltitudine di vibrazioni sonore.
Mentre ascoltavo con oscurità e melodia,
ombra e suono colmarono la stanza,
Non potei fare a meno di ricordare che il grande compositore,
che versò nel mondo un sì dolce fiume di armonia,
era sordo come me.
Mi meravigliai della forza del suo spirito inesauribile
che dal dolore seppe trarre
tanta gioia per gli altri.
E lì rimasi, percependo con la mia mano
la magnifica sinfonia che si infrangeva come un mare
sulle rive silenziose della sua anima e della mia.
Lasciate che vi ringrazi caldamente per tutta la gioia
che la vostra meravigliosa musica ha portato
a me e alla mia casa.
Con i più cordiali saluti e migliori auguri,
vostra devotissima,
Helen Keller
`


const COLS = 16
const set = new Set()

console.log(text.length)
for (let i=0; i < text.length; i++){
  if (text.charAt(i) != '\n'){
    set.add(text.charAt(i))
  }
}

console.log(set.size)
let s = ''

for (const char of set){
  s += char
  if (s.length===COLS){
    console.log(s)
    s = ''
  }
}

console.log(s)

// // unicode points
// for (let i=0; i<set.size; i++){
//   console.log(`map U+${s.codePointAt(i).toString(16)}=${i}`)
// }