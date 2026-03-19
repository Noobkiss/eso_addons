LibHyper = {
    colors = {
        white = {1, 1, 1},
        black = {0, 0, 0},
        gray = {0.5, 0.5, 0.5},
        red = {1, 0, 0},
        green = {0, 1, 0},
        yellow = {1, 1, 0},
        blue = {0, 0, 1},
        teal = {0, 1, 1},
        orange = {1, 0.5, 0},
        purple = {0.5, 0, 1},
        pink = {1, 0, 1},
        lightPink = {1, 0.5, 1},
        lightPurple = {0.75, 0.5, 1},
        lightYellow = {1, 1, 0.5},
        lightBlue = {0.5, 0.5, 1},
        lightRed = {1, 0.5, 0.5},
        lightGreen = {0.5, 1, 0.5},
        lightGray = {0.75, 0.75, 0.75},
        darkPink = {0.5, 0, 0.5},
        darkPurple = {0, 0, 0.5},
        darkYellow = {0.5, 0.5, 0},
        darkBlue = {0, 0, 0.5},
        darkRed = {0.5, 0, 0},
        darkGreen = {0, 0.5, 0},
        darkGray = {0.25, 0.25, 0.25},
        lightGray = {0.75, 0.75, 0.75},
        transparentWhite = {1, 1, 1, 0.8},
        transparentWhite2 = {1, 1, 1, 0.6},
        transparentBlack = {0, 0, 0, 0.8},
        transparentBlack2 = {0, 0, 0, 0.6},
        transparent = {0,0,0,0},

    },
    classIds = {1,2,3,4,5,6,117},
    classColors = {
        --[1] = {0.9, 0.47, 0.1, 1}, --Dragonknight
        --[2] = {0.35, 0.41, 0.7, 1}, --Sorcerer
        --[3] = {0.56, 0.08, 0.1, 1}, --Nightblade
        --[4] = {0.09, 0.79, 0.6, 1}, --Warden
        --[5] = {0.25, 0.19, 0.5 ,1}, --Necromancer
        --[6] = {0.88, 0.71, 0.29, 1}, --Templar
        [0] = {1, 1, 1, 1}, --Loading screen
        [1] = {1, 0.4, 0, 1}, --Dragonknight
        [2] = {0, 0.6, 1, 1}, --Sorcerer
        [3] = {0.7, 0, 0, 1}, --Nightblade
        [4] = {0, 1, 0.7, 1}, --Warden
        [5] = {0.5, 0, 1 ,1}, --Necromancer
        [6] = {1, 0.8, 0, 1}, --Templar
        [117] = {0.1, 0.9, 0, 1}, --Arcanist
    },
    fonts = {
        ['Base Game Medium'] = 'EsoUI/Common/Fonts/Univers57.otf',
        ['Base Game Bold'] = 'EsoUI/Common/Fonts/Univers67.otf',
        ['Base Game Chat'] = 'EsoUI/Common/Fonts/Univers57.otf',
        ['Base Game Antique'] = 'EsoUI/Common/Fonts/ProseAntiquePSMT.otf',
        ['Base Game Gamepad Bold'] = 'EsoUI/Common/Fonts/FTN87.otf',
        ['Base Game Gamepad Light'] = 'EsoUI/Common/Fonts/FTN47.otf',
        ['Base Game Gamepad Medium'] = 'EsoUI/Common/Fonts/FTN57.otf',
        ['Base Game Handwritten'] = 'EsoUI/Common/Fonts/Handwritten_Bold.otf',
        ['Base Game Stone Tablet'] = 'EsoUI/Common/Fonts/TrajanPro-Regular.otf',
        ['Barlow Semi-Condensed Semi-Bold'] = 'LibHyper/fonts/BarlowSemiCondensed-SemiBold.otf',
        ['Generica'] = 'LibHyper/fonts/generica.otf',
        ['Generica Bold'] ='LibHyper/fonts/genericaBold.otf',
    },
    fontWeights = {
        'none',
        'outline',
        'thin-outline',
        'thick-outline',
        'shadow',
        'soft-shadow-thin',
        'soft-shadow-thick',
    },
    fontSizes = {
    8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,28,30,32,34,36,40,48,54
    },

    barTextures = {
        ['Plain'] = '',
        ['Banto Bar'] = 'LibHyper/barTextures/BantoBar.dds',
        ['Gradient Bar'] = 'LibHyper/barTextures/GradientBar.dds',
        ['Gradient Bar 2'] = 'LibHyper/barTextures/GradientBar2.dds',
        ['Gradient Bar Flipped'] = 'LibHyper/barTextures/GradientBarFlipped.dds',
        ['Gradient Bar 2 Flipped'] = 'LibHyper/barTextures/GradientBarFlipped2.dds',
        ['Minimalist Bar'] = 'LibHyper/barTextures/MinimalistBar.dds',
        ['Grainy Bar'] = 'LibHyper/barTextures/bar_grainy.dds',
    },
    anchors = {
        ['TOPLEFT'] = TOPLEFT,
        ['TOP'] = TOP,
        ['TOPRIGHT'] = TOPRIGHT,
        ['LEFT'] = LEFT,
        ['CENTER'] = CENTER,
        ['RIGHT'] = RIGHT,
        ['BOTTOMLEFT'] = BOTTOMLEFT,
        ['BOTTOM'] = BOTTOM,
        ['BOTTOMRIGHT'] = BOTTOMRIGHT,
    }

}