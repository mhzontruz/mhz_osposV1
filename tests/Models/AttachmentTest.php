<?php

namespace Tests\Models;

use App\Models\Attachment;
use CodeIgniter\Test\CIUnitTestCase;
use CodeIgniter\Test\DatabaseTestTrait;
use Tests\Support\DatabaseBootstrapTrait;

class AttachmentTest extends CIUnitTestCase
{
    use DatabaseTestTrait;
    use DatabaseBootstrapTrait;

    protected $migrate     = true;
    protected $migrateOnce = true;
    protected $seedOnce    = true;
    protected $refresh     = false;
    protected $namespace   = null;

    protected function setUp(): void
    {
        $this->resetDatabaseOnce();

        parent::setUp();
    }

    public function testSavePrimaryImage_ReplacesExistingImageForSameOwner(): void
    {
        $attachment = model(Attachment::class);
        $entityId = random_int(10000, 99999);

        $firstId = $attachment->savePrimaryImage('item', $entityId, [
            'file_name' => 'first.png',
            'mime_type' => 'image/png',
            'file_size' => 4,
            'file_data' => "\x00\x01\x02\x03",
        ]);
        $secondId = $attachment->savePrimaryImage('item', $entityId, [
            'file_name' => 'second.jpg',
            'mime_type' => 'image/jpeg',
            'file_size' => 3,
            'file_data' => "\x04\x05\x06",
        ]);

        $this->assertIsInt($firstId);
        $this->assertSame($firstId, $secondId);
        $this->assertSame('second.jpg', $attachment->getPrimaryImage('item', $entityId)['file_name']);
        $this->assertSame("\x04\x05\x06", $attachment->getPrimaryImage('item', $entityId)['file_data']);
    }

    public function testGetPrimaryImage_IsolatesAttachmentOwnerType(): void
    {
        $attachment = model(Attachment::class);
        $entityId = random_int(10000, 99999);

        $attachment->savePrimaryImage('item', $entityId, [
            'file_name' => 'item.png',
            'mime_type' => 'image/png',
            'file_size' => 1,
            'file_data' => 'i',
        ]);
        $attachment->savePrimaryImage('customer', $entityId, [
            'file_name' => 'customer.png',
            'mime_type' => 'image/png',
            'file_size' => 1,
            'file_data' => 'c',
        ]);

        $this->assertSame('item.png', $attachment->getPrimaryImage('item', $entityId)['file_name']);
        $this->assertSame('customer.png', $attachment->getPrimaryImage('customer', $entityId)['file_name']);
    }
}
