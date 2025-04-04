<?php

namespace App\Http\Requests\Issue;

use Illuminate\Foundation\Http\FormRequest;

class StoreIssueRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            "title" => ["required"],
            "description" => ["sometimes", "required"],
            "proyectId" => ["required"],
            "tag" => ["required"],
            "priority" => ["required"],
            "time" => ["required"],
            "users" => ["sometimes", "required", "array"]
        ];
    }
}
