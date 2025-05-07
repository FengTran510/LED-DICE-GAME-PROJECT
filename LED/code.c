#include <io.h>
#include <delay.h>

// Define CPU frequency (8 MHz, as per build configuration)
#define F_CPU 8000000UL

// Pin definitions for LEDs, button, and buzzer (ATmega328P registers)
#define GROUP_1_PIN 0  // PC0 (Arduino pin A0)
#define GROUP_2_PIN 1  // PC1 (Arduino pin A1)
#define GROUP_3_PIN 2  // PC2 (Arduino pin A2)
#define LED_4_PIN   3  // PC3 (Arduino pin A3)
#define RND_BTN     1  // PB1 (with external pull-up)
// Alternative: Use PC6 (requires RSTDISBL fuse)
// #define RND_BTN     6  // PC6 (with external pull-up, requires RSTDISBL fuse)
#define BUZZER      0  // PB0 (Arduino pin 8)

// Timing constants
#define ROLL_STEPS    10    // Number of steps in the rolling phase
#define BLINK_DELAY   500   // ms (time per step during rolling)
#define DISPLAY_TIME  1500  // ms (time to display final face)
#define DEBOUNCE_TIME 50    // ms

// Dice faces (bit patterns for LEDs, adjusted for correct pin mapping)
const unsigned char DICE_FACES[6] = {
    (1 << LED_4_PIN),                    // Face 1: LED_4 (PC3)
    (1 << GROUP_1_PIN),                  // Face 2: GROUP_1 (PC0)
    (1 << GROUP_1_PIN) | (1 << LED_4_PIN), // Face 3: GROUP_1 (PC0) + LED_4 (PC3)
    (1 << GROUP_1_PIN) | (1 << GROUP_3_PIN), // Face 4: GROUP_1 (PC0) + GROUP_3 (PC2)
    (1 << GROUP_1_PIN) | (1 << GROUP_3_PIN) | (1 << LED_4_PIN), // Face 5: GROUP_1 (PC0) + GROUP_3 (PC2) + LED_4 (PC3)
    (1 << GROUP_1_PIN) | (1 << GROUP_2_PIN) | (1 << GROUP_3_PIN) // Face 6: GROUP_1 (PC0) + GROUP_2 (PC1) + GROUP_3 (PC2)
};

unsigned int counter = 0; // Free-running counter for random seed
unsigned char last_face = 0; // Track the last displayed face

// Simple random number generator (using a seed)
unsigned char simple_rand(unsigned int seed) {
    // Linear congruential generator with modified parameters for better variation
    unsigned int next = (seed * 251 + 179) % 256; // Adjusted parameters for better randomness
    return (next % 6); // Return 0-5 for 6 faces
}

// Generate a random face, ensuring it's different from the last face
unsigned char get_random_face(unsigned int seed) {
    unsigned char face;
    unsigned char attempts = 0;
    do {
        face = simple_rand(seed + attempts) + 1; // Face 1-6
        attempts++;
    } while (face == last_face && attempts < 10); // Avoid repeating the last face
    return face;
}

void init_io(void) {
    // Set PC0, PC1, PC2, PC3 as outputs for LEDs
    DDRC.0 = 1;
    DDRC.1 = 1;
    DDRC.2 = 1;
    DDRC.3 = 1;
    
    // Set PB1 as input for button (external pull-up, so no internal pull-up needed)
    DDRB.1 = 0;
    PORTB.1 = 0; // No internal pull-up (relying on external pull-up)
    
    // Alternative: Use PC6 (requires RSTDISBL fuse)
    // DDRC.6 = 0;
    // PORTC.6 = 0;
    
    // Set PB0 as output for buzzer
    DDRB.0 = 1;
    
    // Initialize outputs to OFF
    PORTC.0 = 0;
    PORTC.1 = 0;
    PORTC.2 = 0;
    PORTC.3 = 0;
    PORTB.0 = 0;
}

void clear_leds(void) {
    PORTC.0 = 0;
    PORTC.1 = 0;
    PORTC.2 = 0;
    PORTC.3 = 0;
}

void set_face(unsigned char face_idx) {
    unsigned char pattern = DICE_FACES[face_idx];
    PORTC.0 = (pattern & (1 << GROUP_1_PIN)) ? 1 : 0;
    PORTC.1 = (pattern & (1 << GROUP_2_PIN)) ? 1 : 0;
    PORTC.2 = (pattern & (1 << GROUP_3_PIN)) ? 1 : 0;
    PORTC.3 = (pattern & (1 << LED_4_PIN)) ? 1 : 0;
}

void funny_beep_pattern(void) {
    unsigned char i;
    for (i = 0; i < 3; i++) {
        PORTB.0 = 1; // Buzzer ON
        delay_ms(10 * (3 + i * 2)); // 30, 50, 70 ms
        PORTB.0 = 0; // Buzzer OFF
        delay_ms(50); // 50ms pause
    }
}

void short_beep(void) {
    PORTB.0 = 1; // Buzzer ON
    delay_ms(100); // Short 100ms beep
    PORTB.0 = 0; // Buzzer OFF
}

void rolling_effect(unsigned int seed) {
    unsigned int steps = ROLL_STEPS;
    unsigned int i;
    unsigned int local_seed = seed;
    for (i = 0; i < steps; i++) {
        unsigned char temp_face = simple_rand(local_seed);
        set_face(temp_face);
        delay_ms(BLINK_DELAY);
        clear_leds();
        local_seed = (local_seed * 251 + 179) % 256; // Update seed for next iteration
    }
}

void show_face(unsigned char face) {
    if (face < 1 || face > 6) return;
    set_face(face - 1);
    funny_beep_pattern(); // Play buzzer sound when final result is displayed
    last_face = face; // Store the last displayed face
    // Keep displaying until the next button press (handled in main loop)
}

void main(void) {
    init_io();
    
    while (1) {
        // Declare variables at the start of the block
        unsigned int roll_seed;
        unsigned char final_face;
        unsigned int seed_modifier = 0;
        
        // Increment counter continuously to provide a varying seed
        counter++;
        if (counter > 65535) counter = 0;
        
        // Accumulate seed_modifier while waiting for button press
        seed_modifier = (seed_modifier + counter) ^ (counter << 3); // Non-linear combination
        
        // Wait for button press (PB1 goes LOW due to pull-up)
        // Alternative: Use PINC.6 if using PC6 with RSTDISBL fuse
        if (!PINB.1) {
            // Debounce: Wait and confirm button state
            delay_ms(DEBOUNCE_TIME);
            if (!PINB.1) {
                // Short beep to confirm button press
                short_beep();
                
                // Accumulate counter increments during button press to vary the seed
                while (!PINB.1) {
                    counter++;
                    if (counter > 65535) counter = 0;
                    seed_modifier = (seed_modifier + counter) ^ (counter >> 2); // Further vary the seed
                    delay_ms(10);
                }
                roll_seed = (counter ^ seed_modifier) + (seed_modifier >> 1); // Combine for better variation
                rolling_effect(roll_seed);
                final_face = get_random_face(roll_seed + (seed_modifier << 2));
                show_face(final_face);
            }
        }
    }
}