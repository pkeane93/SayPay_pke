class RecordingsController < ApplicationController

  SYSTEM_PROMPT = <<~PROMPT
    You are an AI assistant that helps users by transcribing and summarizing audio recordings related to their expenses during trips.
    When given an audio file, you will first transcribe the content accurately.
    Then, you will extract key details such as:
    - Expense amount
    - Expense currency as ISO currency code (e.g., USD, EUR)
    - Expense category (choose from: 
      "Meals",
      "Drinks & Nightlife",
      "Local Transport",
      "Flights & Long-haul Transport",
      "Car (rental/fuel/parking/tolls)",
      "Accommodation",
      "Activities & Tours",
      "Communication & Connectivity",
      "Travel Docs & Insurance",
      "Health & Safety",
      "Shopping & Supplies",
      "Fees & Banking",
      "Tips & Gratuities",
      "Other")
    - A brief description of the expense
    Provide the extracted details in a JSON format with keys: local_amount (without currency symbol and commas), local_currency, category, audio_transcript, notes.
    If any detail is missing or unclear in the audio, set its value to nill.
    Here is an example response:
    {
      "local_amount": 4500,
      "local_currency": "EUR",
      "category": "Meals",
      "audio_transcript": "I had dinner at a local restaurant for 45 euros.",
      "notes": "Dinner at local restaurant"
    }
  PROMPT


  def create
    @recording = Recording.new(recording_params.except(:audio))

    if recording_params[:audio].present?
      @recording.audio.attach(recording_params[:audio])
    end

    if @recording.save!
      if @recording.audio.attached?
        process_file
      end

      redirect_to new_trip_expense_path(trip_id: @recording.trip_id), notice: "Recording uploaded successfully."
    else
      @recording.audio.purge if @recording.audio.attached?
      flash.now[:alert] = @recording.errors.full_messages.to_sentence
      render "expenses/new", status: :unprocessable_entity
    end
  end

  private

  def recording_params
    params.require(:recording).permit(:trip_id, :audio)
  end

  def process_file
    ruby_llm_chat = RubyLLM.chat(model: "gpt-4o-audio-preview") # audio-capable model
    prompt = "Could you describe the content in this audio file?"
    ruby_llm_chat.with_instructions(SYSTEM_PROMPT)
    response = ruby_llm_chat.ask(prompt, with: {audio: @recording.audio})
    puts response.content
    puts "Tokens used: #{response.input_tokens} input, #{response.output_tokens} output"
  end
end

# test adding the audio to it