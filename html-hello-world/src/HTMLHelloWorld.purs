module HTMLHelloWorld
    ( helloWorld
    ) where

import Elmish (ReactElement)
import Elmish.HTML as R

helloWorld :: ReactElement
helloWorld =
    R.article { className: "container" }
        [ R.h1 {} "PureScript Elmish: HTML Hello World"
        , R.p {}
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit.\
            \ Curabitur massa sapien, convallis sed commodo eget, dictum a nunc.\
            \ Nunc cursus porta quam ut porttitor. Sed et faucibus magna.\
            \ Praesent id nibh quis elit placerat venenatis vehicula at quam.\
            \ Duis tristique velit sit amet orci fringilla varius.\
            \ Integer mollis fermentum magna. Etiam id rutrum mi. Cras mollis\
            \ ex eget velit interdum, ut porttitor erat pulvinar.\
            \ Nulla eleifend cursus lacus vitae molestie."
        , R.img
            { src: "http://placekitten.com/780/540"
            , width: "780"
            , height: "540"
            }
        , R.p {}
            "Pellentesque libero mi, feugiat at ligula et, blandit\
            \ sollicitudin sem. Maecenas ex risus, volutpat at dui eget,\
            \ tristique posuere justo. Fusce fermentum metus euismod,\
            \ scelerisque mi at, blandit nibh. Phasellus eu bibendum velit.\
            \ Pellentesque turpis neque, aliquet quis ultricies in, feugiat ut\
            \ urna. Vestibulum dui sem, semper vitae placerat sed, pretium et\
            \ mauris. Curabitur id diam aliquet purus accumsan sodales eu\
            \ quis odio. Phasellus ornare lacus mi, quis feugiat quam\
            \ dignissim non."
        ]
