<?php
namespace App\DTOs;

class JobDTO
{
    public string $title;
    public ?string $description;
    public ?string $location;
    public ?float $salary;

    public function __construct(array $data)
    {
        $this->title = $data['title'];
        $this->description = $data['description'] ?? null;
        $this->location = $data['location'] ?? null;
        $this->salary = isset($data['salary']) ? (float) $data['salary'] : null;
    }
}